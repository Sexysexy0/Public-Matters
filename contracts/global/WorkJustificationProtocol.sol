// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract WorkJustificationProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct LaborAudit {
        uint256 id;
        string workerGroup;
        string justificationTrigger; // e.g., "48-hour assignment", "Code printout demand"
        bool fearLogicBlocked;
        bool dignityAuditActivated;
        string emotionalTag; // e.g., "Labor sovereignty restored"
        string restorationClause;
        uint256 timestamp;
    }

    uint256 public nextAuditId = 1;
    mapping(uint256 => LaborAudit> public audits;

    event ValidatorSet(address indexed account, bool status);
    event LaborAuditActivated(uint256 indexed id, string workerGroup, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateLaborAudit(
        string calldata workerGroup,
        string calldata justificationTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextAuditId++;
        audits[id] = LaborAudit({
            id: id,
            workerGroup: workerGroup,
            justificationTrigger: justificationTrigger,
            fearLogicBlocked: true,
            dignityAuditActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit LaborAuditActivated(id, workerGroup, emotionalTag);
    }

    function getLaborAudit(uint256 id) external view returns (LaborAudit memory) {
        return audits[id];
    }
}
