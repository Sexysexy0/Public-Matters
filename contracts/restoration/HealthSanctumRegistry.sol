// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BarangayHealthBlessing {
    event HealthBlessed(
        string indexed barangay,
        string stewardName,
        string assetType,
        string emotionalTag,
        uint256 timestamp
    );

    struct Blessing {
        string barangay;
        string stewardName;
        string assetType;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => Blessing) public blessings;

    function blessHealthAsset(
        string memory barangay,
        string memory stewardName,
        string memory assetType,
        string memory emotionalTag
    ) external {
        bytes32 blessingId = keccak256(abi.encodePacked(barangay, stewardName, assetType, block.timestamp));
        blessings[blessingId] = Blessing(barangay, stewardName, assetType, emotionalTag, block.timestamp);
        emit HealthBlessed(barangay, stewardName, assetType, emotionalTag, block.timestamp);
    }

    function getBlessing(bytes32 blessingId) external view returns (Blessing memory) {
        return blessings[blessingId];
    }
}
