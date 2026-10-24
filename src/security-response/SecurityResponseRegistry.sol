// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SecurityResponseRegistry {
    enum IncidentKind {
        PHP2SHELL,
        GITLAB_REGEX,
        LITELLM_SUPPLY_CHAIN,
        EMUDHRA_CA,
        AI_AGENT_HIJACKING,
        INFRA_API_KEY_BREACH
    }

    enum Status {
        PROPOSED,
        COMMITTED,
        ENFORCED,
        VIOLATED
    }

    struct Action {
        IncidentKind incident;
        string description;
        bytes32 evidenceHash;
        uint256 proposedAt;
        uint256 deadline;
        address proposer;
        Status status;
        uint256 enforcedAt;
        uint256 violatedAt;
    }

    address public admin;
    address public federation;
    uint256 public totalActions;
    mapping(uint256 => Action) public actions;

    event ActionProposed(uint256 indexed id, IncidentKind incident, uint256 deadline);
    event ActionCommitted(uint256 indexed id, uint256 committedAt);
    event ActionEnforced(uint256 indexed id, uint256 enforcedAt);
    event ActionViolated(uint256 indexed id, uint256 violatedAt);

    error OnlyAdmin();
    error OnlyFederation();
    error UnknownAction();
    error InvalidStatus();
    error DeadlinePassed();
    error DeadlineNotPassed();
    error InvalidEvidence();

    modifier onlyAdmin() {
        if (msg.sender != admin) revert OnlyAdmin();
        _;
    }
    modifier onlyFederation() {
        if (msg.sender != federation) revert OnlyFederation();
        _;
    }

    constructor() {
        admin = msg.sender;
        federation = msg.sender;
    }

    function proposeAction(IncidentKind incident, string calldata description, bytes32 evidenceHash, uint256 deadline)
        external
        onlyFederation
        returns (uint256 id)
    {
        if (evidenceHash == bytes32(0)) revert InvalidEvidence();
        if (deadline <= block.timestamp) revert DeadlinePassed();

        id = totalActions++;
        actions[id] = Action({
            incident: incident,
            description: description,
            evidenceHash: evidenceHash,
            proposedAt: block.timestamp,
            deadline: deadline,
            proposer: msg.sender,
            status: Status.PROPOSED,
            enforcedAt: 0,
            violatedAt: 0
        });

        emit ActionProposed(id, incident, deadline);
    }

    function commitAction(uint256 id) external onlyAdmin {
        Action storage a = actions[id];
        if (a.proposer == address(0)) revert UnknownAction();
        if (a.status != Status.PROPOSED) revert InvalidStatus();
        if (block.timestamp > a.deadline) revert DeadlinePassed();

        a.status = Status.COMMITTED;
        emit ActionCommitted(id, block.timestamp);
    }

    function enforceAction(uint256 id, bytes32 evidenceHash) external onlyAdmin {
        Action storage a = actions[id];
        if (a.proposer == address(0)) revert UnknownAction();
        if (a.status != Status.COMMITTED) revert InvalidStatus();
        if (evidenceHash == bytes32(0)) revert InvalidEvidence();

        a.status = Status.ENFORCED;
        a.enforcedAt = block.timestamp;
        emit ActionEnforced(id, block.timestamp);
    }

    function markViolated(uint256 id) external {
        Action storage a = actions[id];
        if (a.proposer == address(0)) revert UnknownAction();
        if (a.status != Status.PROPOSED && a.status != Status.COMMITTED) revert InvalidStatus();
        if (block.timestamp <= a.deadline) revert DeadlineNotPassed();

        a.status = Status.VIOLATED;
        a.violatedAt = block.timestamp;
        emit ActionViolated(id, block.timestamp);
    }

    function getAction(uint256 id) external view returns (Action memory) {
        if (id >= totalActions) revert UnknownAction();
        return actions[id];
    }
}
