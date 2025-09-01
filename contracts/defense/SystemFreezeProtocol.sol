// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SystemFreezeProtocol {
    struct Node {
        string identifier;
        string region;
        bool isHostile;
        bool isFrozen;
        uint256 timestamp;
    }

    mapping(string => Node) public nodes;
    string[] public frozenNodes;

    event NodeFlagged(string identifier, string region, bool isHostile, uint256 timestamp);
    event NodeFrozen(string identifier, string region, uint256 timestamp);

    function flagNode(string memory _identifier, string memory _region, bool _isHostile) public {
        require(bytes(_identifier).length > 0, "Invalid node ID");
        uint256 time = block.timestamp;

        nodes[_identifier] = Node(_identifier, _region, _isHostile, false, time);
        emit NodeFlagged(_identifier, _region, _isHostile, time);
    }

    function freezeNode(string memory _identifier) public {
        require(nodes[_identifier].isHostile, "Node not flagged as hostile");
        require(!nodes[_identifier].isFrozen, "Node already frozen");

        nodes[_identifier].isFrozen = true;
        frozenNodes.push(_identifier);

        emit NodeFrozen(_identifier, nodes[_identifier].region, block.timestamp);
    }

    function getFrozenNodes() public view returns (string[] memory) {
        return frozenNodes;
    }
}
