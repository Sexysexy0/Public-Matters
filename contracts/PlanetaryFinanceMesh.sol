// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlanetaryFinanceMesh
/// @notice Covenant contract to unify transparency, council, and DAO safeguards into planetary-scale finance mesh
contract PlanetaryFinanceMesh {
    address public owner;

    struct Node {
        string name;          // e.g. "ReserveTransparency", "CouncilGovernance", "GlobalReserveDAO"
        address linkedContract; // linked safeguard contract
        string domain;        // e.g. "Transparency", "Council", "DAO"
        uint256 timestamp;
    }

    Node[] public nodes;

    event NodeRegistered(string name, address linkedContract, string domain, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new safeguard node in the planetary finance mesh
    function registerNode(string memory name, address linkedContract, string memory domain) public onlyOwner {
        Node memory newNode = Node(name, linkedContract, domain, block.timestamp);
        nodes.push(newNode);
        emit NodeRegistered(name, linkedContract, domain, block.timestamp);
    }

    function getNode(uint256 index) public view returns (string memory, address, string memory, uint256) {
        Node memory n = nodes[index];
        return (n.name, n.linkedContract, n.domain, n.timestamp);
    }

    function getNodeCount() public view returns (uint256) {
        return nodes.length;
    }
}
