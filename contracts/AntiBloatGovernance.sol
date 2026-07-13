// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anti Bloat Governance
/// @notice Limits management layers and prevents corporate hierarchy bloat
contract AntiBloatGovernance {
    address public guardian;
    uint256 public maxLayers;
    uint256 public managerCount;
    uint256 public violationCount;

    struct Manager {
        uint256 id;
        address account;
        uint256 layer;
        string role;
        bool active;
    }

    struct Violation {
        uint256 id;
        address manager;
        uint256 attemptedLayer;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Manager) public managers;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event ManagerAdded(uint256 indexed id, address account, uint256 layer, string role);
    event ViolationLogged(uint256 indexed id, address manager, uint256 attemptedLayer, string reason);
    event MaxLayersChanged(uint256 oldMax, uint256 newMax);

    constructor() {
        guardian = msg.sender;
        maxLayers = 4; // Default: 4 layers max (Creator → Lead → Director → Guardian)
        managerCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function setMaxLayers(uint256 newMax) external onlyGuardian {
        require(newMax >= 1, "Must allow at least one layer");
        emit MaxLayersChanged(maxLayers, newMax);
        maxLayers = newMax;
    }

    function addManager(
        address account,
        uint256 layer,
        string calldata role
    ) external onlyGuardian {
        if (layer > maxLayers) {
            _logViolation(account, layer, "Manager exceeds allowed hierarchy layers");
            return;
        }

        managerCount++;
        managers[managerCount] = Manager(managerCount, account, layer, role, true);
        emit ManagerAdded(managerCount, account, layer, role);
    }

    function _logViolation(
        address manager,
        uint256 attemptedLayer,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            manager,
            attemptedLayer,
            reason,
            block.timestamp
        );
        emit ViolationLogged(violationCount, manager, attemptedLayer, reason);
    }

    function logViolation(
        address manager,
        uint256 attemptedLayer,
        string calldata reason
    ) external onlyGuardian {
        _logViolation(manager, attemptedLayer, reason);
    }

    function viewManager(uint256 id) external view returns (Manager memory) {
        return managers[id];
    }

    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
