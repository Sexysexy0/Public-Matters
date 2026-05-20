// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * IntegrityBridge
 * Bridge safeguard para mag-link ng ResilienceOracle alerts
 * sa ContinuityVault at TransparencyShield.
 */
contract IntegrityBridge {
    address public owner;
    address public continuityVault;
    address public transparencyShield;

    struct Alert {
        uint256 id;
        string advisoryId;   // e.g. GHSA-58qx-3vcg-4xpx
        string description;  // advisory summary
        uint256 timestamp;
        bool resolved;
    }

    uint256 public nextAlertId;
    mapping(uint256 => Alert) public alerts;

    event AlertLogged(uint256 indexed id, string advisoryId, string description);
    event AlertResolved(uint256 indexed id, address indexed resolver);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _continuityVault, address _transparencyShield) {
        owner = msg.sender;
        continuityVault = _continuityVault;
        transparencyShield = _transparencyShield;
    }

    // Log new advisory alert
    function logAlert(string calldata advisoryId, string calldata description) external onlyOwner {
        alerts[nextAlertId] = Alert({
            id: nextAlertId,
            advisoryId: advisoryId,
            description: description,
            timestamp: block.timestamp,
            resolved: false
        });
        emit AlertLogged(nextAlertId, advisoryId, description);
        nextAlertId++;
    }

    // Resolve advisory alert
    function resolveAlert(uint256 id) external onlyOwner {
        require(!alerts[id].resolved, "Already resolved");
        alerts[id].resolved = true;
        emit AlertResolved(id, msg.sender);
    }

    // Retrieve advisory alert details
    function getAlert(uint256 id) external view returns (Alert memory) {
        return alerts[id];
    }
}
