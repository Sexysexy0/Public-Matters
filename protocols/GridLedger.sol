// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// GridLedger: record national rail grid nodes and links
contract GridLedger {
    struct Node {
        uint256 id;
        string name;       // e.g., "Malolos City Hub"
        string type;       // "Barangay", "City", "Regional"
        uint256 timestamp;
    }

    struct Link {
        uint256 id;
        uint256 fromNode;
        uint256 toNode;
        uint256 distanceKm;
        uint256 timestamp;
    }

    uint256 public nextNodeId;
    uint256 public nextLinkId;
    mapping(uint256 => Node) public nodes;
    mapping(uint256 => Link) public links;
    mapping(address => bool) public stewards;

    event NodeLogged(uint256 indexed id, string name, string type);
    event LinkLogged(uint256 indexed id, uint256 fromNode, uint256 toNode);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logNode(string calldata name, string calldata type) external {
        require(stewards[msg.sender], "Only steward");
        nodes[nextNodeId] = Node(nextNodeId, name, type, block.timestamp);
        emit NodeLogged(nextNodeId, name, type);
        nextNodeId++;
    }

    function logLink(uint256 fromNode, uint256 toNode, uint256 distanceKm) external {
        require(stewards[msg.sender], "Only steward");
        links[nextLinkId] = Link(nextLinkId, fromNode, toNode, distanceKm, block.timestamp);
        emit LinkLogged(nextLinkId, fromNode, toNode);
        nextLinkId++;
    }
}
