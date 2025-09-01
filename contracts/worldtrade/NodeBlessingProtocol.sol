// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NodeBlessingProtocol {
    struct NodeProfile {
        string country;
        uint256 empathy;
        uint256 trust;
        uint256 clarity;
        uint256 blessingTimestamp;
        bool blessed;
    }

    mapping(string => NodeProfile) public nodes;
    string[] public nodeList;

    event NodeBlessed(string country, uint256 empathy, uint256 trust, uint256 clarity, uint256 timestamp);

    function blessNode(
        string memory _country,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        uint256 timestamp = block.timestamp;
        nodes[_country] = NodeProfile(_country, _empathy, _trust, _clarity, timestamp, true);
        nodeList.push(_country);
        emit NodeBlessed(_country, _empathy, _trust, _clarity, timestamp);
    }

    function getNodeProfile(string memory _country) public view returns (NodeProfile memory) {
        return nodes[_country];
    }

    function listBlessedNodes() public view returns (string[] memory) {
        return nodeList;
    }
}
