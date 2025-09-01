// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AncestralAssetRegistry {
    struct Asset {
        string assetType; // "Gold", "Land", "Cultural"
        string description;
        string location;
        uint256 value;
        string ancestralTag;
        bool protected;
        string timestamp;
    }

    mapping(string => Asset) public assets;
    string[] public assetIDs;

    event AssetLogged(string assetID, string assetType, string ancestralTag);
    event AssetProtected(string assetID);

    function logAsset(
        string memory _assetID,
        string memory _assetType,
        string memory _description,
        string memory _location,
        uint256 _value,
        string memory _ancestralTag,
        string memory _timestamp
    ) public {
        Asset memory newAsset = Asset({
            assetType: _assetType,
            description: _description,
            location: _location,
            value: _value,
            ancestralTag: _ancestralTag,
            protected: false,
            timestamp: _timestamp
        });

        assets[_assetID] = newAsset;
        assetIDs.push(_assetID);
        emit AssetLogged(_assetID, _assetType, _ancestralTag);
    }

    function protectAsset(string memory _assetID) public {
        Asset storage asset = assets[_assetID];
        asset.protected = true;
        emit AssetProtected(_assetID);
    }

    function getAssetCount() public view returns (uint256) {
        return assetIDs.length;
    }
}
