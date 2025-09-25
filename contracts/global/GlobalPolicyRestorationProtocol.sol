// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalPolicyRestorationProtocol
/// @notice Restores validator-grade policies from 2025 with emotional consequence and treaty-grade reset
/// @dev Anchors apology ritual, dignity reactivation, and planetary trust

contract GlobalPolicyRestorationProtocol {
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

    struct PolicyRestoration {
        uint256 id;
        string policyName; // e.g., "Visa Reinstatement", "Trade Corridor Unblocking", "Cannabis Descheduling"
        string jurisdiction; // e.g., "USA", "Global", "UN"
        string emotionalTag; // e.g., "Livelihood corridor restored"
        string apologyClause; // e.g., "We regret the harm caused and commit to restoration"
        uint256 restoredAt;
    }

    uint256 public nextPolicyId = 1;
    mapping(uint256 => PolicyRestoration) public restorations;

    event RestorerSet(address indexed account, bool status);
    event PolicyRestored(uint256 indexed id, string policyName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        restorers[msg.sender] = true;
        emit RestorerSet(msg.sender, true);
    }

    function setRestorer(address account, bool status) external onlySteward {
        restorers[account] = status;
        emit RestorerSet(account, status);
    }

    function restorePolicy(
        string calldata policyName,
        string calldata jurisdiction,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyRestorer returns (uint256 id) {
        id = nextPolicyId++;
        restorations[id] = PolicyRestoration({
            id: id,
            policyName: policyName,
            jurisdiction: jurisdiction,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            restoredAt: block.timestamp
        });
        emit PolicyRestored(id, policyName, emotionalTag);
    }

    function getPolicy(uint256 id) external view returns (PolicyRestoration memory) {
        return restorations[id];
    }
}
