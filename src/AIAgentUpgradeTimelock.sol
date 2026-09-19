// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentUpgradeTimelock
 * @notice Time-delayed AI agent upgrades. Prevents silent model swaps.
 */
contract AIAgentUpgradeTimelock {
    OperatorPrivileges public privileges;

    uint256 public constant MIN_DELAY = 1 hours;
    uint256 public constant MAX_DELAY = 30 days;
    uint256 public defaultDelay = 2 days;

    struct Upgrade {
        bytes32 agentId;
        bytes32 newModelHash;
        string metadataURI;
        uint256 scheduledAt;
        uint256 eta;
        bool executed;
        bool cancelled;
        address scheduledBy;
    }

    mapping(bytes32 => Upgrade) internal _upgrades;
    mapping(bytes32 => bool) public hasPending;

    event UpgradeScheduled(bytes32 indexed agentId, bytes32 newModelHash, uint256 eta, address scheduledBy);
    event UpgradeExecuted(bytes32 indexed agentId, bytes32 newModelHash, address executedBy);
    event UpgradeCancelled(bytes32 indexed agentId, address cancelledBy);
    event DefaultDelayUpdated(uint256 oldDelay, uint256 newDelay);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function scheduleUpgrade(
        bytes32 agentId,
        bytes32 newModelHash,
        string calldata metadataURI,
        uint256 delay
    ) external onlyOperator {
        require(!hasPending[agentId], "Upgrade already pending");
        require(newModelHash != bytes32(0), "Invalid model hash");

        uint256 useDelay = delay == 0 ? defaultDelay : delay;
        require(useDelay >= MIN_DELAY && useDelay <= MAX_DELAY, "Invalid delay");

        _upgrades[agentId] = Upgrade({
            agentId: agentId,
            newModelHash: newModelHash,
            metadataURI: metadataURI,
            scheduledAt: block.timestamp,
            eta: block.timestamp + useDelay,
            executed: false,
            cancelled: false,
            scheduledBy: msg.sender
        });

        hasPending[agentId] = true;

        emit UpgradeScheduled(agentId, newModelHash, block.timestamp + useDelay, msg.sender);
    }

    function executeUpgrade(bytes32 agentId) external onlyOperator {
        Upgrade storage u = _upgrades[agentId];
        require(hasPending[agentId], "No pending upgrade");
        require(block.timestamp >= u.eta, "Timelock not expired");
        require(!u.executed, "Already executed");
        require(!u.cancelled, "Cancelled");

        u.executed = true;
        hasPending[agentId] = false;

        emit UpgradeExecuted(agentId, u.newModelHash, msg.sender);
    }

    function cancelUpgrade(bytes32 agentId) external onlyOperator {
        Upgrade storage u = _upgrades[agentId];
        require(hasPending[agentId], "No pending upgrade");
        require(!u.executed, "Already executed");

        u.cancelled = true;
        hasPending[agentId] = false;

        emit UpgradeCancelled(agentId, msg.sender);
    }

    function setDefaultDelay(uint256 newDelay) external onlyOperator {
        require(newDelay >= MIN_DELAY && newDelay <= MAX_DELAY, "Invalid delay");
        uint256 old = defaultDelay;
        defaultDelay = newDelay;
        emit DefaultDelayUpdated(old, newDelay);
    }

    function getUpgrade(bytes32 agentId) external view returns (Upgrade memory) {
        return _upgrades[agentId];
    }

    function getUpgradeETA(bytes32 agentId) external view returns (uint256) {
        return _upgrades[agentId].eta;
    }
}
