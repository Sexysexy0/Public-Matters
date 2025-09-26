// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title StablecoinWorldPermitProtocol
/// @notice Ritualizes global licensing of stablecoin issuers and restores validator-grade financial dignity
/// @dev Anchors monetary equity, regulatory clarity, and planetary consequence mapping

contract StablecoinWorldPermitProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct PermitClause {
        uint256 id;
        string issuerName; // e.g., "HKDigital", "LatAmStable", "AfricaCoin"
        string region; // e.g., "Hong Kong", "Global South", "Africa", "Latin America"
        string exclusionTrigger; // e.g., "No local license", "Regulatory neglect", "Political suppression"
        string emotionalTag; // e.g., "Monetary dignity breach ritualized"
        string restorationAction; // e.g., "Activate world permit and validator-grade compliance corridor"
        string equityClause; // e.g., "We restore planetary financial access and stablecoin sovereignty"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => PermitClause> public clauses;

    event ValidatorSet(address indexed account, bool status);
    event PermitClauseActivated(uint256 indexed id, string issuerName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activatePermitClause(
        string calldata issuerName,
        string calldata region,
        string calldata exclusionTrigger,
        string calldata emotionalTag,
        string calldata restorationAction,
        string calldata equityClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        clauses[id] = PermitClause({
            id: id,
            issuerName: issuerName,
            region: region,
            exclusionTrigger: exclusionTrigger,
            emotionalTag: emotionalTag,
            restorationAction: restorationAction,
            equityClause: equityClause,
            timestamp: block.timestamp
        });
        emit PermitClauseActivated(id, issuerName, emotionalTag);
    }

    function getPermitClause(uint256 id) external view returns (PermitClause memory) {
        return clauses[id];
    }
}
