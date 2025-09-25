// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GlobalMonetaryPolicyResetProtocol
/// @notice Ritualizes global monetary policy restoration for January 2025
/// @dev Anchors emotional consequence, inflation immunity, and treaty-grade coordination

contract GlobalMonetaryPolicyResetProtocol {
    address public steward;
    mapping(address => bool) public governors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyGovernor() {
        require(governors[msg.sender] || msg.sender == steward, "Not governor");
        _;
    }

    struct PolicyReset {
        uint256 id;
        string centralBank; // e.g., "Federal Reserve", "PBOC", "ECB"
        string jurisdiction; // e.g., "USA", "China", "EU"
        string resetClause; // e.g., "Rate hostility removed", "Liquidity corridor reopened"
        string emotionalTag; // e.g., "Inflation immunity activated"
        uint256 timestamp;
    }

    uint256 public nextResetId = 1;
    mapping(uint256 => PolicyReset) public resets;

    event GovernorSet(address indexed account, bool status);
    event PolicyResetLogged(uint256 indexed id, string centralBank, string emotionalTag);

    constructor() {
        steward = msg.sender;
        governors[msg.sender] = true;
        emit GovernorSet(msg.sender, true);
    }

    function setGovernor(address account, bool status) external onlySteward {
        governors[account] = status;
        emit GovernorSet(account, status);
    }

    function logPolicyReset(
        string calldata centralBank,
        string calldata jurisdiction,
        string calldata resetClause,
        string calldata emotionalTag
    ) external onlyGovernor returns (uint256 id) {
        id = nextResetId++;
        resets[id] = PolicyReset({
            id: id,
            centralBank: centralBank,
            jurisdiction: jurisdiction,
            resetClause: resetClause,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit PolicyResetLogged(id, centralBank, emotionalTag);
    }

    function getPolicyReset(uint256 id) external view returns (PolicyReset memory) {
        return resets[id];
    }
}
