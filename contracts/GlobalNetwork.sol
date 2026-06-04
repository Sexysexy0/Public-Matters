// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalNetwork
/// @notice Covenant contract to interconnect governance nodes across nations
contract GlobalNetwork {
    address public owner;

    struct Node {
        string country;      // e.g. "Philippines", "Japan", "USA"
        string purpose;      // e.g. "Tax Reform DAO", "Democracy Safeguard"
        address nodeAddress; // DAO node address
        uint256 timestamp;
    }

    Node[] public nodes;

    event NodeRegistered(string country, string purpose, address nodeAddress, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new governance node
    function registerNode(string memory country, string memory purpose, address nodeAddress) public onlyOwner {
        Node memory newNode = Node(country, purpose, nodeAddress, block.timestamp);
        nodes.push(newNode);
        emit NodeRegistered(country, purpose, nodeAddress, block.timestamp);
    }

    function getNode(uint256 index) public view returns (string memory, string memory, address, uint256) {
        Node memory n = nodes[index];
        return (n.country, n.purpose, n.nodeAddress, n.timestamp);
    }

    function getNodeCount() public view returns (uint256) {
        return nodes.length;
    }
}
