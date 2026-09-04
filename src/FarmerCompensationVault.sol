// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title FarmerCompensationVault
 * @author The Source
 * @notice Locks funds for farmers displaced by the impounding project.
 * @dev Releases compensation only via verified NexusID.
 */
contract FarmerCompensationVault {
    address public admin;
    address public nexusID;
    bool public active;
    uint256 public totalLocked;
    uint256 public totalClaimed;

    struct FarmerClaim {
        address farmer;
        uint256 landArea; // In hectares
        uint256 compensationAmount;
        uint256 cropYieldHistory; // Average yield over 3 years
        bool verified;
        bool claimed;
        uint256 timestamp;
        string location; // Barangay/Sitio
    }

    mapping(address => FarmerClaim) public farmers;
    mapping(address => bool) public isVerifier;
    address[] public farmerList;

    event FarmerVerified(address indexed farmer, uint256 landArea, uint256 compensation);
    event CompensationClaimed(address indexed farmer, uint256 amount);
    event FundsDeposited(address indexed from, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyVerifier() {
        require(isVerifier[msg.sender], "Not a verifier");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor(address _nexusID) {
        admin = msg.sender;
        nexusID = _nexusID;
        active = true;
        totalLocked = 0;
        totalClaimed = 0;
        isVerifier[msg.sender] = true;
    }

    function addVerifier(address _verifier) public onlyAdmin whenActive {
        isVerifier[_verifier] = true;
    }

    function removeVerifier(address _verifier) public onlyAdmin whenActive {
        isVerifier[_verifier] = false;
    }

    function registerFarmer(
        address _farmer,
        uint256 _landArea,
        uint256 _compensationAmount,
        uint256 _cropYieldHistory,
        string memory _location
    ) public onlyVerifier whenActive {
        require(farmers[_farmer].farmer == address(0), "Farmer already registered");
        require(_landArea > 0, "Land area must be > 0");
        require(_compensationAmount > 0, "Compensation must be > 0");

        farmers[_farmer] = FarmerClaim({
            farmer: _farmer,
            landArea: _landArea,
            compensationAmount: _compensationAmount,
            cropYieldHistory: _cropYieldHistory,
            verified: true,
            claimed: false,
            timestamp: block.timestamp,
            location: _location
        });

        farmerList.push(_farmer);
        emit FarmerVerified(_farmer, _landArea, _compensationAmount);
    }

    function claimCompensation() public whenActive {
        FarmerClaim storage farmer = farmers[msg.sender];
        require(farmer.farmer == msg.sender, "Not registered");
        require(farmer.verified, "Not verified");
        require(!farmer.claimed, "Already claimed");
        require(address(this).balance >= farmer.compensationAmount, "Insufficient funds");

        uint256 amount = farmer.compensationAmount;
        farmer.claimed = true;
        totalClaimed += amount;

        payable(msg.sender).transfer(amount);
        emit CompensationClaimed(msg.sender, amount);
    }

    function deposit() public payable {
        require(msg.value > 0, "Must send ETH");
        totalLocked += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function getFarmerCount() public view returns (uint256) {
        return farmerList.length;
    }

    function getFarmer(address _farmer) public view returns (FarmerClaim memory) {
        return farmers[_farmer];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }

    // Allow contract to receive ETH
    receive() external payable {
        totalLocked += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }
}
