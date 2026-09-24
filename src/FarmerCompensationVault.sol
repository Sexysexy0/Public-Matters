// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {OperatorPrivileges} from "./OperatorPrivileges.sol";

contract FarmerCompensationVault {
    OperatorPrivileges public immutable privileges;
    address public nexusID;
    bool public active;
    uint256 public totalLocked;
    uint256 public totalClaimed;
    bool private locked; 

    struct FarmerClaim {
        address farmer;
        uint256 landArea; 
        uint256 compensationAmount;
        uint256 cropYieldHistory; 
        bool verified;
        bool claimed;
        uint256 timestamp;
        string location; 
    }

    mapping(address => FarmerClaim) public farmers;
    mapping(address => bool) public isVerifier;
    address[] public farmerList;

    event VerifierStatusUpdated(address indexed verifier, bool indexed status);
    event FarmerVerified(address indexed farmer, uint256 landArea, uint256 compensation);
    event CompensationClaimed(address indexed farmer, uint256 amount);
    event FundsDeposited(address indexed from, uint256 amount);

    modifier nonReentrant() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    modifier onlySystemAdmin() {
        require(privileges.isOperator(msg.sender), "Not enterprise system operator");
        _;
    }

    modifier onlyVerifier() {
        require(isVerifier[msg.sender], "Not an authorized verifier");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor(address _privilegesAddress, address _nexusID) {
        require(_nexusID != address(0), "NexusID validation zero-check gate");
        privileges = OperatorPrivileges(_privilegesAddress);
        nexusID = _nexusID;
        active = true;
        isVerifier[msg.sender] = true;
        emit VerifierStatusUpdated(msg.sender, true);
    }

    function addVerifier(address _verifier) public onlySystemAdmin whenActive {
        require(_verifier != address(0), "Zero address input validation guard");
        isVerifier[_verifier] = true;
        emit VerifierStatusUpdated(_verifier, true);
    }

    function removeVerifier(address _verifier) public onlySystemAdmin whenActive {
        require(_verifier != address(0), "Zero address input validation guard");
        isVerifier[_verifier] = false;
        emit VerifierStatusUpdated(_verifier, false);
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
        
        // Fixed: Emit the logging events BEFORE any external interaction patterns
        emit FarmerVerified(_farmer, _landArea, _compensationAmount);
        privileges.logAction(_farmer, 5); 
    }

    // Fixed: Placed nonReentrant as the absolute first modifier block to clear linter rules
    function claimCompensation() public nonReentrant whenActive {
        FarmerClaim storage farmer = farmers[msg.sender];
        require(farmer.farmer == msg.sender, "Not registered");
        require(farmer.verified, "Not verified");
        require(!farmer.claimed, "Already claimed");
        require(address(this).balance >= farmer.compensationAmount, "Insufficient vault balance");

        uint256 amount = farmer.compensationAmount;
        farmer.claimed = true;
        totalClaimed += amount;

        // Fixed: Synchronize system state variables prior to running low-level transfer payloads
        privileges.logAction(msg.sender, 15);
        emit CompensationClaimed(msg.sender, amount);

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Compensation payment transfer failed");
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

    function toggleActive() public onlySystemAdmin {
        active = !active;
    }

    receive() external payable {
        totalLocked += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }
}
