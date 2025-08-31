// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SignalGridMesh {
    struct Node {
        string location;
        bool isOnline;
        uint256 lastPing;
    }

    mapping(bytes32 => Node) public nodes;
    event NodePinged(bytes32 indexed nodeId, bool isOnline);

    function pingNode(string memory location, bool isOnline) public {
        bytes32 nodeId = keccak256(abi.encodePacked(location));
        nodes[nodeId] = Node(location, isOnline, block.timestamp);
        emit NodePinged(nodeId, isOnline);
    }

    function getNodeStatus(string memory location) public view returns (Node memory) {
        bytes32 nodeId = keccak256(abi.encodePacked(location));
        return nodes[nodeId];
    }
}
