// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalAudit
/// @notice Covenant contract to interconnect institutional audits across nations
contract GlobalAudit {
    address public owner;

    struct AuditNode {
        string country;      // e.g. "Philippines", "Japan", "USA"
        string institution;  // e.g. "Congress", "Judiciary", "Military"
        address auditContract; // linked InstitutionalAudit or AuditTransparency contract
        uint256 timestamp;
    }

    AuditNode[] public nodes;

    event NodeRegistered(string country, string institution, address auditContract, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new audit node
    function registerNode(string memory country, string memory institution, address auditContract) public onlyOwner {
        AuditNode memory newNode = AuditNode(country, institution, auditContract, block.timestamp);
        nodes.push(newNode);
        emit NodeRegistered(country, institution, auditContract, block.timestamp);
    }

    function getNode(uint256 index) public view returns (string memory, string memory, address, uint256) {
        AuditNode memory n = nodes[index];
        return (n.country, n.institution, n.auditContract, n.timestamp);
    }

    function getNodeCount() public view returns (uint256) {
        return nodes.length;
    }
}
