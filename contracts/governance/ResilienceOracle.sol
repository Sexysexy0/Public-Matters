// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * ResilienceOracle
 * Oracle contract para sa systemic resilience monitoring.
 * - Owner: highest authority (Vinvin)
 * - Members: watchers / auditors
 * - Functions: log CVE, emit alerts, link to SupplyChainAuditShield
 */
contract ResilienceOracle {
    address public owner;
    mapping(address => bool) public watchers;

    struct CVEAlert {
        uint256 id;
        string packageName;
        string cveId;
        string severity;
        string description;
        uint256 timestamp;
        bool resolved;
    }

    uint256 public nextAlertId;
    mapping(uint256 => CVEAlert) public alerts;

    event WatcherAdded(address indexed watcher);
    event WatcherRemoved(address indexed watcher);
    event AlertLogged(uint256 indexed id, string packageName, string cveId, string severity);
    event AlertResolved(uint256 indexed id, address indexed resolver);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyWatcher() {
        require(watchers[msg.sender], "Not watcher");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Governance: add/remove watchers
    function addWatcher(address watcher) external onlyOwner {
        watchers[watcher] = true;
        emit WatcherAdded(watcher);
    }

    function removeWatcher(address watcher) external onlyOwner {
        watchers[watcher] = false;
        emit WatcherRemoved(watcher);
    }

    // Log new CVE alert
    function logAlert(
        string calldata packageName,
        string calldata cveId,
        string calldata severity,
        string calldata description
    ) external onlyWatcher {
        alerts[nextAlertId] = CVEAlert({
            id: nextAlertId,
            packageName: packageName,
            cveId: cveId,
            severity: severity,
            description: description,
            timestamp: block.timestamp,
            resolved: false
        });
        emit AlertLogged(nextAlertId, packageName, cveId, severity);
        nextAlertId++;
    }

    // Resolve CVE alert
    function resolveAlert(uint256 id) external onlyWatcher {
        require(!alerts[id].resolved, "Already resolved");
        alerts[id].resolved = true;
        emit AlertResolved(id, msg.sender);
    }

    // Owner override
    function forceResolve(uint256 id) external onlyOwner {
        alerts[id].resolved = true;
        emit AlertResolved(id, msg.sender);
    }
}
