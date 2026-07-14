// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PowerThrottle
/// @notice Governance safeguard to throttle unchecked technological power
contract PowerThrottle {
    address public guardian;
    uint256 public councilThreshold;

    enum Role { None, Guardian, Council }
    mapping(address => Role) public roles;

    // --- Events ---
    event RoleAssigned(address indexed who, Role role);
    event RoleRevoked(address indexed who);
    event UsageRecorded(bytes32 indexed toolId, address indexed user, uint256 timestamp);
    event ThrottleTriggered(bytes32 indexed toolId, address indexed triggeredBy);
    event EmergencyFreeze(bytes32 indexed identifier, address indexed triggeredBy);
    event EmergencyLift(bytes32 indexed identifier, address indexed liftedBy);

    // --- Usage tracking ---
    struct Usage {
        uint256 count;
        uint256 lastReset;
    }
    mapping(bytes32 => Usage) public usageStats;

    // --- Limits ---
    uint256 public constant USAGE_LIMIT = 100; // configurable threshold
    uint256 public constant RESET_WINDOW = 1 days;

    // --- Emergency freeze registry ---
    mapping(bytes32 => bool) public frozenIdentifiers;

    // --- Council members ---
    address[] public councilMembers;
    mapping(address => bool) public isCouncilMember;

    // --- Constructor ---
    constructor(address[] memory initialCouncil, uint256 _councilThreshold) {
        guardian = msg.sender;
        roles[msg.sender] = Role.Guardian;
        emit RoleAssigned(msg.sender, Role.Guardian);

        require(_councilThreshold > 0 && _councilThreshold <= initialCouncil.length, "Invalid threshold");
        councilThreshold = _councilThreshold;

        for (uint i = 0; i < initialCouncil.length; i++) {
            address m = initialCouncil[i];
            roles[m] = Role.Council;
            isCouncilMember[m] = true;
            councilMembers.push(m);
            emit RoleAssigned(m, Role.Council);
        }
    }

    // --- Role management ---
    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(isCouncilMember[msg.sender], "Council only");
        _;
    }

    function assignRole(address who, Role r) external onlyGuardian {
        roles[who] = r;
        if (r == Role.Council && !isCouncilMember[who]) {
            isCouncilMember[who] = true;
            councilMembers.push(who);
        }
        emit RoleAssigned(who, r);
    }

    function revokeRole(address who) external onlyGuardian {
        roles[who] = Role.None;
        if (isCouncilMember[who]) {
            isCouncilMember[who] = false;
        }
        emit RoleRevoked(who);
    }

    // --- Usage recording and throttle ---
    function recordUsage(bytes32 toolId) external {
        Usage storage u = usageStats[toolId];
        if (block.timestamp > u.lastReset + RESET_WINDOW) {
            u.count = 0;
            u.lastReset = block.timestamp;
        }
        u.count++;
        emit UsageRecorded(toolId, msg.sender, block.timestamp);

        if (u.count > USAGE_LIMIT) {
            frozenIdentifiers[toolId] = true;
            emit ThrottleTriggered(toolId, msg.sender);
        }
    }

    // --- Emergency freeze / lift ---
    function emergencyFreeze(bytes32 identifier) external onlyCouncil {
        frozenIdentifiers[identifier] = true;
        emit EmergencyFreeze(identifier, msg.sender);
    }

    function emergencyLift(bytes32 identifier) external onlyGuardian {
        frozenIdentifiers[identifier] = false;
        emit EmergencyLift(identifier, msg.sender);
    }

    // --- View helpers ---
    function isFrozen(bytes32 identifier) external view returns (bool) {
        return frozenIdentifiers[identifier];
    }
}
