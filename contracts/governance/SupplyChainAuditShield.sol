// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * SupplyChainAuditShield
 * Safeguard contract para sa dependency audit trail.
 * - Owner: highest authority (Vinvin)
 * - Members: auditors / maintainers
 * - Functions: log dependency, verify integrity, flag vulnerability
 */
contract SupplyChainAuditShield {
    address public owner;
    mapping(address => bool) public auditors;

    struct Dependency {
        uint256 id;
        string name;
        string version;
        string hash;
        bool safe;
        uint256 timestamp;
    }

    uint256 public nextDependencyId;
    mapping(uint256 => Dependency) public dependencies;

    event AuditorAdded(address indexed auditor);
    event AuditorRemoved(address indexed auditor);
    event DependencyLogged(uint256 indexed id, string name, string version, string hash);
    event DependencyVerified(uint256 indexed id, bool safe);
    event DependencyFlagged(uint256 indexed id, string reason);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender], "Not auditor");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Governance: add/remove auditors
    function addAuditor(address auditor) external onlyOwner {
        auditors[auditor] = true;
        emit AuditorAdded(auditor);
    }

    function removeAuditor(address auditor) external onlyOwner {
        auditors[auditor] = false;
        emit AuditorRemoved(auditor);
    }

    // Log new dependency
    function logDependency(string calldata name, string calldata version, string calldata hash) external onlyAuditor {
        dependencies[nextDependencyId] = Dependency({
            id: nextDependencyId,
            name: name,
            version: version,
            hash: hash,
            safe: false,
            timestamp: block.timestamp
        });
        emit DependencyLogged(nextDependencyId, name, version, hash);
        nextDependencyId++;
    }

    // Verify dependency integrity
    function verifyDependency(uint256 id, bool safe) external onlyAuditor {
        dependencies[id].safe = safe;
        emit DependencyVerified(id, safe);
    }

    // Flag vulnerability
    function flagDependency(uint256 id, string calldata reason) external onlyAuditor {
        dependencies[id].safe = false;
        emit DependencyFlagged(id, reason);
    }
}
