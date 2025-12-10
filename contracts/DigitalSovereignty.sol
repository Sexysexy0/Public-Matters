// contracts/DigitalSovereignty.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DigitalSovereignty
 * @notice Protocols for data ownership, privacy, and communal control of digital assets.
 */
contract DigitalSovereignty {
    address public admin;

    struct Asset {
        string name;
        string owner;
        bool repairable;
        string note;
        uint256 timestamp;
    }

    Asset[] public assets;

    event AssetRegistered(string name, string owner, bool repairable, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerAsset(string calldata name, string calldata owner, bool repairable, string calldata note) external onlyAdmin {
        assets.push(Asset(name, owner, repairable, note, block.timestamp));
        emit AssetRegistered(name, owner, repairable, note, block.timestamp);
    }

    function totalAssets() external view returns (uint256) {
        return assets.length;
    }

    function getAsset(uint256 id) external view returns (Asset memory) {
        require(id < assets.length, "Invalid id");
        return assets[id];
    }
}
