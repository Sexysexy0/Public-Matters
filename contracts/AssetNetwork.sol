// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AssetNetwork
/// @notice Covenant contract to connect cashflow assets into a global resilience network
contract AssetNetwork {
    address public owner;

    struct AssetNode {
        string name;         // e.g. "Rental Property", "Dividend Stock", "AI Business"
        string type;         // e.g. "Real Estate", "Equity", "Digital Enterprise"
        address linkedContract; // linked safeguard contract (CashflowResilience, AILeverage, etc.)
        uint256 timestamp;
    }

    AssetNode[] public nodes;

    event NodeRegistered(string name, string type, address linkedContract, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new asset node in the global network
    function registerNode(string memory name, string memory type, address linkedContract) public onlyOwner {
        AssetNode memory newNode = AssetNode(name, type, linkedContract, block.timestamp);
        nodes.push(newNode);
        emit NodeRegistered(name, type, linkedContract, block.timestamp);
    }

    function getNode(uint256 index) public view returns (string memory, string memory, address, uint256) {
        AssetNode memory n = nodes[index];
        return (n.name, n.type, n.linkedContract, n.timestamp);
    }

    function getNodeCount() public view returns (uint256) {
        return nodes.length;
    }
}
