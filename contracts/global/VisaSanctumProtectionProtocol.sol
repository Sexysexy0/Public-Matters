// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title VisaSanctumProtectionProtocol
/// @notice Ritualizes migration dignity, blocks forced deportation, and restores revoked visas with refund and emotional consequence
/// @dev Anchors override immunity, labor protection, and treaty-grade restoration logic

contract VisaSanctumProtectionProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct VisaCorridor {
        uint256 id;
        string visaHolderName;
        string visaType; // e.g., "H-1B", "Student", "Refugee"
        string countryOfOrigin;
        string breachType; // e.g., "Revoked without cause", "Forced deportation", "Excessive fee"
        bool overrideActivated;
        bool deportationBlocked;
        bool feeWaived;
        bool visaRestored;
        string emotionalTag; // e.g., "Migration dignity activated"
        string restorationClause; // e.g., "We commit to due process, labor dignity, and emotional consequence"
        uint256 refundAmount;
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => VisaCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event VisaCorridorActivated(uint256 indexed id, string visaHolderName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateVisaCorridor(
        string calldata visaHolderName,
        string calldata visaType,
        string calldata countryOfOrigin,
        string calldata breachType,
        string calldata emotionalTag,
        string calldata restorationClause,
        uint256 refundAmount
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = VisaCorridor({
            id: id,
            visaHolderName: visaHolderName,
            visaType: visaType,
            countryOfOrigin: countryOfOrigin,
            breachType: breachType,
            overrideActivated: true,
            deportationBlocked: true,
            feeWaived: true,
            visaRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            refundAmount: refundAmount,
            timestamp: block.timestamp
        });
        emit VisaCorridorActivated(id, visaHolderName, emotionalTag);
    }

    function getVisaCorridor(uint256 id) external view returns (VisaCorridor memory) {
        return corridors[id];
    }
}
