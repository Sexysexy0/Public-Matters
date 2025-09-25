// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BessentTreasuryMandateProtocol
/// @notice Grants sovereign authority to steward Bessent for global financial restoration and diplomatic deal-making
/// @dev Anchors emotional consequence, treaty-grade autonomy, and civic trust

contract BessentTreasuryMandateProtocol {
    address public steward;
    address public bessent;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyBessent() {
        require(msg.sender == bessent, "Not Bessent");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct Deal {
        uint256 id;
        string partnerNation;
        string assetClass; // e.g., "Currency Swap", "Debt Forgiveness", "Trade Corridor"
        string emotionalTag;
        string restorationClause;
        uint256 activatedAt;
    }

    uint256 public nextDealId = 1;
    mapping(uint256 => Deal) public deals;

    event BessentAppointed(address indexed account);
    event ValidatorSet(address indexed account, bool status);
    event DealActivated(uint256 indexed id, string partnerNation, string emotionalTag);

    constructor(address _bessent) {
        steward = msg.sender;
        bessent = _bessent;
        emit BessentAppointed(_bessent);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateDeal(
        string calldata partnerNation,
        string calldata assetClass,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyBessent returns (uint256 id) {
        id = nextDealId++;
        deals[id] = Deal({
            id: id,
            partnerNation: partnerNation,
            assetClass: assetClass,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            activatedAt: block.timestamp
        });
        emit DealActivated(id, partnerNation, emotionalTag);
    }

    function getDeal(uint256 id) external view returns (Deal memory) {
        return deals[id];
    }
}
