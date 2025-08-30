// SPDX-License-Identifier: Restoration-License
pragma solidity ^0.8.19;

contract BankAssetRecoverySuite {
    struct Asset {
        address site;
        string typeTag;
        bool isRebuilt;
        bool isOperational;
        string emotionalTag;
    }

    mapping(address => Asset) public recoveredAssets;
    address public steward;

    event AssetRecovered(address site, string typeTag, string emotionalTag);
    event AssetRebuilt(address site);
    event AssetActivated(address site);

    constructor() {
        steward = msg.sender;
    }

    function recoverAsset(address site, string memory typeTag, string memory emotionalTag) public {
        require(msg.sender == steward, "Unauthorized steward");
        recoveredAssets[site] = Asset(site, typeTag, false, false, emotionalTag);
        emit AssetRecovered(site, typeTag, emotionalTag);
    }

    function rebuildAsset(address site) public {
        require(msg.sender == steward, "Unauthorized");
        recoveredAssets[site].isRebuilt = true;
        emit AssetRebuilt(site);
    }

    function activateAsset(address site) public {
        require(recoveredAssets[site].isRebuilt, "Asset not rebuilt");
        recoveredAssets[site].isOperational = true;
        emit AssetActivated(site);
    }
}
