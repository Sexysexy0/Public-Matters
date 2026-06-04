// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalInvestorNetwork
/// @notice Covenant contract to connect investor resilience modules into planetary-scale governance and asset networks
contract GlobalInvestorNetwork {
    address public owner;

    struct Node {
        string name;          // e.g. "InvestorResilience", "OwnershipDAO", "TransparencyModule"
        address linkedContract; // linked safeguard contract
        string region;        // e.g. "Asia", "Europe", "Global"
        uint256 timestamp;
    }

    Node[] public nodes;

    event NodeRegistered(string name, address linkedContract, string region, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new investor resilience node in the global network
    function registerNode(string memory name, address linkedContract, string memory region) public onlyOwner {
        Node memory newNode = Node(name, linkedContract, region, block.timestamp);
        nodes.push(newNode);
        emit NodeRegistered(name, linkedContract, region, block.timestamp);
    }

    function getNode(uint256 index) public view returns (string memory, address, string memory, uint256) {
        Node memory n = nodes[index];
        return (n.name, n.linkedContract, n.region, n.timestamp);
    }

    function getNodeCount() public view returns (uint256) {
        return nodes.length;
    }
}
