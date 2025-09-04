// SPDX-License-Identifier: Mythic-Barangay
pragma solidity ^0.8.19;

contract BarangayAssetAudit {
    address public steward;

    struct Asset {
        string assetType;
        uint256 value;
        uint256 emotionalAPR;
        string tag;
        bool taxed;
        uint256 timestamp;
    }

    mapping(address => Asset[]) public assetLedger;

    event AssetLogged(
        address indexed owner,
        string assetType,
        uint256 value,
        uint256 emotionalAPR,
        string tag,
        bool taxed,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function logAsset(
        address owner,
        string memory assetType,
        uint256 value,
        uint256 emotionalAPR,
        string memory tag,
        bool taxed
    ) public {
        require(msg.sender == steward, "Only steward may log.");

        Asset memory newAsset = Asset({
            assetType: assetType,
            value: value,
            emotionalAPR: emotionalAPR,
            tag: tag,
            taxed: taxed,
            timestamp: block.timestamp
        });

        assetLedger[owner].push(newAsset);

        emit AssetLogged(owner, assetType, value, emotionalAPR, tag, taxed, block.timestamp);
    }

    function getAssets(address owner) public view returns (Asset[] memory) {
        return assetLedger[owner];
    }
}
