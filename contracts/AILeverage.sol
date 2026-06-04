// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AILeverage
/// @notice Covenant contract to encode AI leverage as multiplier of asset ownership and cashflow
contract AILeverage {
    address public owner;

    struct LeveragedAsset {
        string name;         // e.g. "AI Business", "Automated Trading Bot"
        string type;         // e.g. "Digital Enterprise", "Financial System"
        uint256 baseValue;   // original value of asset
        uint256 leverageFactor; // multiplier applied via AI leverage
        uint256 leveragedValue; // computed value after leverage
        uint256 timestamp;
    }

    LeveragedAsset[] public leveragedAssets;

    event AssetLeveraged(string name, string type, uint256 baseValue, uint256 leverageFactor, uint256 leveragedValue, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new leveraged asset
    function logLeveragedAsset(string memory name, string memory type, uint256 baseValue, uint256 leverageFactor) public onlyOwner {
        uint256 leveragedValue = baseValue * leverageFactor;
        LeveragedAsset memory newAsset = LeveragedAsset(name, type, baseValue, leverageFactor, leveragedValue, block.timestamp);
        leveragedAssets.push(newAsset);
        emit AssetLeveraged(name, type, baseValue, leverageFactor, leveragedValue, block.timestamp);
    }

    function getLeveragedAsset(uint256 index) public view returns (string memory, string memory, uint256, uint256, uint256, uint256) {
        LeveragedAsset memory a = leveragedAssets[index];
        return (a.name, a.type, a.baseValue, a.leverageFactor, a.leveragedValue, a.timestamp);
    }

    function getLeveragedAssetCount() public view returns (uint256) {
        return leveragedAssets.length;
    }
}
