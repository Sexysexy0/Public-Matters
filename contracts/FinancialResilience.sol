// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FinancialResilience
/// @notice Covenant contract to safeguard against paycheck trap by encoding asset ownership and AI leverage
contract FinancialResilience {
    address public owner;

    struct Asset {
        string name;         // e.g. "Rental Property", "Dividend Stock", "AI Business"
        string type;         // e.g. "Real Estate", "Equity", "Digital Enterprise"
        uint256 value;       // placeholder for asset valuation
        uint256 timestamp;
    }

    Asset[] public assets;

    event AssetLogged(string name, string type, uint256 value, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new asset for financial resilience
    function logAsset(string memory name, string memory type, uint256 value) public onlyOwner {
        Asset memory newAsset = Asset(name, type, value, block.timestamp);
        assets.push(newAsset);
        emit AssetLogged(name, type, value, block.timestamp);
    }

    function getAsset(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Asset memory a = assets[index];
        return (a.name, a.type, a.value, a.timestamp);
    }

    function getAssetCount() public view returns (uint256) {
        return assets.length;
    }
}
