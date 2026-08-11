// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GenerativeSocialContract {
    struct SocialFund {
        uint256 housingReserve;
        uint256 maternalHealthReserve;
        uint256 emergencyReserve;
        bool active;
    }

    mapping(address => SocialFund) public communityVaults;
    address public immutable digitalComptroller;

    event ContributionAllocated(address indexed contributor, uint256 totalAmount, uint256 safetyNetShare);
    event FundsDisbursed(address indexed recipient, uint256 amount, string category);

    modifier onlyComptroller() {
        require(msg.sender == digitalComptroller, "Unauthorized: Comptroller only");
        _;
    }

    constructor() {
        digitalComptroller = msg.sender;
    }

    // Tumatanggap ng pondo at awtomatikong hinahati para sa social safety nets
    function contributeToSociety() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");

        uint256 total = msg.value;
        // 40% sa Housing, 40% sa Maternal & Health Safety, 20% sa Emergency Reserve
        uint256 housingShare = (total * 40) / 100;
        uint256 healthShare = (total * 40) / 100;
        uint256 emergencyShare = total - housingShare - healthShare;

        SocialFund storage vault = communityVaults[msg.sender];
        vault.housingReserve += housingShare;
        vault.maternalHealthReserve += healthShare;
        vault.emergencyReserve += emergencyShare;
        vault.active = true;

        emit ContributionAllocated(msg.sender, total, housingShare + healthShare + emergencyShare);
    }

    // Pamamahagi ng pondo para sa totoong pangangailangan ng komunidad (May transparency at pananagutan)
    function disburseSafetyNet(
        address payable _recipient,
        uint256 _amount,
        string memory _category
    ) external onlyComptroller {
        require(_recipient != address(0), "Invalid recipient");
        
        if (keccak256(bytes(_category)) == keccak256(bytes("housing"))) {
            require(address(this).balance >= _amount, "Insufficient vault balance");
            _recipient.transfer(_amount);
        } else if (keccak256(bytes(_category)) == keccak256(bytes("maternal_health"))) {
            require(address(this).balance >= _amount, "Insufficient vault balance");
            _recipient.transfer(_amount);
        } else if (keccak256(bytes(_category)) == keccak256(bytes("emergency"))) {
            require(address(this).balance >= _amount, "Insufficient vault balance");
            _recipient.transfer(_amount);
        } else {
            revert("Invalid safety net category");
        }

        emit FundsDisbursed(_recipient, _amount, _category);
    }

    function getVaultBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
