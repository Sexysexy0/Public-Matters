// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract InfluenceMapAudit {
    struct Node {
        string name;
        uint256 influenceScore;
        string emotionalAPR;
        uint256 timestamp;
    }

    Node[] public nodes;

    event NodeLogged(string name, uint256 influenceScore, string emotionalAPR);

    function logNode(string memory name, uint256 influenceScore, string memory emotionalAPR) public {
        nodes.push(Node(name, influenceScore, emotionalAPR, block.timestamp));
        emit NodeLogged(name, influenceScore, emotionalAPR);
    }

    function getAllNodes() public view returns (Node[] memory) {
        return nodes;
    }
}
