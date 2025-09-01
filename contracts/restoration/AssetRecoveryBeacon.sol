// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract AssetRecoveryBeacon {
    struct RecoveredAsset {
        string assetType;
        uint256 value;
        string sourceProject;
        address recoveredFrom;
        uint256 timestamp;
        bool returnedToSanctum;
    }

    mapping(bytes32 => RecoveredAsset) public assets;

    event AssetRecovered(
        bytes32 indexed assetId,
        string assetType,
        uint256 value,
        string sourceProject,
        address recoveredFrom,
        bool returnedToSanctum,
        uint256 timestamp
    );

    function logRecoveredAsset(
        string memory assetType,
        uint256 value,
        string memory sourceProject,
        address recoveredFrom,
        bool returnedToSanctum
    ) public {
        bytes32 assetId = keccak256(abi.encodePacked(assetType, value, sourceProject, recoveredFrom, block.timestamp));
        assets[assetId] = RecoveredAsset(
            assetType,
            value,
            sourceProject,
            recoveredFrom,
            block.timestamp,
            returnedToSanctum
        );

        emit AssetRecovered(
            assetId,
            assetType,
            value,
            sourceProject,
            recoveredFrom,
            returnedToSanctum,
            block.timestamp
        );
    }

    function getRecoveredAsset(bytes32 assetId) public view returns (RecoveredAsset memory) {
        return assets[assetId];
    }
}
