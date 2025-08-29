// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ScrollchainAct_0003 {
    address public steward;

    struct SeizedAsset {
        string officialName;
        string position;
        uint256 estimatedValue;
        string assetType; // e.g., "Real Estate", "Bank Account", "Luxury Vehicle"
        string rerouteUse; // e.g., "Barangay Clinic", "Scholarship Fund", "Sanctum Housing"
        uint256 timestamp;
    }

    SeizedAsset[] public assets;

    event AssetSeized(string officialName, string assetType, uint256 value, string rerouteUse, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logSeizure(
        string memory officialName,
        string memory position,
        uint256 estimatedValue,
        string memory assetType,
        string memory rerouteUse
    ) public onlySteward {
        SeizedAsset memory newAsset = SeizedAsset({
            officialName: officialName,
            position: position,
            estimatedValue: estimatedValue,
            assetType: assetType,
            rerouteUse: rerouteUse,
            timestamp: block.timestamp
        });

        assets.push(newAsset);
        emit AssetSeized(officialName, assetType, estimatedValue, rerouteUse, block.timestamp);
    }

    function getAsset(uint256 index) public view returns (SeizedAsset memory) {
        require(index < assets.length, "Invalid index");
        return assets[index];
    }

    function totalSeizedAssets() public view returns (uint256) {
        return assets.length;
    }
}
