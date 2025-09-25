// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ChinaMarketRestorationProtocol
/// @notice Ritualizes a bilateral market reset with China—no enforcement, full apology, and open cooperation
/// @dev Anchors emotional consequence, trade dignity, and planetary trust

contract ChinaMarketRestorationProtocol {
    address public steward;
    address public chinaDelegate;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyDelegate() {
        require(msg.sender == chinaDelegate || msg.sender == steward, "Not delegate");
        _;
    }

    struct RestorationDeal {
        uint256 id;
        string assetClass; // e.g., "Tech", "Agriculture", "Cannabis", "Vape"
        bool enforcementRemoved;
        bool apologyBroadcasted;
        string emotionalTag;
        string resetClause;
        uint256 activatedAt;
    }

    uint256 public nextDealId = 1;
    mapping(uint256 => RestorationDeal) public deals;

    event DelegateSet(address indexed account);
    event ValidatorSet(address indexed account, bool status);
    event DealActivated(uint256 indexed id, string assetClass, string emotionalTag);

    constructor(address _chinaDelegate) {
        steward = msg.sender;
        chinaDelegate = _chinaDelegate;
        validators[msg.sender] = true;
        emit DelegateSet(_chinaDelegate);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateDeal(
        string calldata assetClass,
        string calldata emotionalTag,
        string calldata resetClause
    ) external onlyDelegate returns (uint256 id) {
        id = nextDealId++;
        deals[id] = RestorationDeal({
            id: id,
            assetClass: assetClass,
            enforcementRemoved: true,
            apologyBroadcasted: true,
            emotionalTag: emotionalTag,
            resetClause: resetClause,
            activatedAt: block.timestamp
        });
        emit DealActivated(id, assetClass, emotionalTag);
    }

    function getDeal(uint256 id) external view returns (RestorationDeal memory) {
        return deals[id];
    }
}
