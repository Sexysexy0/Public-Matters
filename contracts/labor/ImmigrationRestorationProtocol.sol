// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ImmigrationRestorationProtocol
/// @notice Reinstates revoked visas and removes immigration crackdown logic
/// @dev Anchors labor dignity, apology ritual, and treaty-grade restoration

contract ImmigrationRestorationProtocol {
    address public steward;
    mapping(address => bool) public restorers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRestorer() {
        require(restorers[msg.sender] || msg.sender == steward, "Not restorer");
        _;
    }

    struct VisaRestoration {
        uint256 id;
        string workerName;
        string employer; // e.g., "GE Appliances"
        string jurisdiction; // e.g., "Kentucky"
        bool crackdownRemoved;
        bool visaReinstated;
        string emotionalTag;
        string apologyClause;
        uint256 timestamp;
    }

    uint256 public nextRestorationId = 1;
    mapping(uint256 => VisaRestoration) public restorations;

    event RestorerSet(address indexed account, bool status);
    event VisaRestored(uint256 indexed id, string workerName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        restorers[msg.sender] = true;
        emit RestorerSet(msg.sender, true);
    }

    function setRestorer(address account, bool status) external onlySteward {
        restorers[account] = status;
        emit RestorerSet(account, status);
    }

    function restoreVisa(
        string calldata workerName,
        string calldata employer,
        string calldata jurisdiction,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyRestorer returns (uint256 id) {
        id = nextRestorationId++;
        restorations[id] = VisaRestoration({
            id: id,
            workerName: workerName,
            employer: employer,
            jurisdiction: jurisdiction,
            crackdownRemoved: true,
            visaReinstated: true,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            timestamp: block.timestamp
        });
        emit VisaRestored(id, workerName, emotionalTag);
    }

    function getRestoration(uint256 id) external view returns (VisaRestoration memory) {
        return restorations[id];
    }
}
