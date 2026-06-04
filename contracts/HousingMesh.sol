// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HousingMesh
/// @notice Covenant contract to unify council, transparency, and safeguard modules into planetary-scale housing governance mesh
contract HousingMesh {
    address public owner;

    struct Node {
        string name;          // e.g. "HousingCouncil", "HousingTransparency", "HousingCollapseSafeguard"
        address linkedContract; // linked safeguard contract
        string domain;        // e.g. "Council", "Transparency", "Safeguard"
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

    /// @notice Register a new governance node in the housing mesh
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
