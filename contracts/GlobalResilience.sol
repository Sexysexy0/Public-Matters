// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalResilience
/// @notice Covenant contract to unify audits, transparency, ethics, and citizen participation across nations
contract GlobalResilience {
    address public owner;

    struct Module {
        string domain;       // e.g. "Audit", "Transparency", "Ethics", "Citizen Participation"
        string description;  // details of safeguard
        address linkedContract; // address of linked module (AuditTransparency, GovernanceDAO, FaithAndTransparency, etc.)
        uint256 timestamp;
    }

    Module[] public modules;

    event ModuleRegistered(string domain, string description, address linkedContract, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new safeguard module
    function registerModule(string memory domain, string memory description, address linkedContract) public onlyOwner {
        Module memory newModule = Module(domain, description, linkedContract, block.timestamp);
        modules.push(newModule);
        emit ModuleRegistered(domain, description, linkedContract, block.timestamp);
    }

    function getModule(uint256 index) public view returns (string memory, string memory, address, uint256) {
        Module memory m = modules[index];
        return (m.domain, m.description, m.linkedContract, m.timestamp);
    }

    function getModuleCount() public view returns (uint256) {
        return modules.length;
    }
}
