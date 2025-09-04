// SPDX-License-Identifier: Mythic-AssetRouter
pragma solidity ^0.8.19;

interface IBarangayAssetAudit {
    function getAssets(address owner) external view returns (
        string memory assetType,
        uint256 value,
        uint256 emotionalAPR,
        string memory tag,
        bool taxed,
        uint256 timestamp
    );
}

contract AssetBlessingRouter {
    address public steward;
    IBarangayAssetAudit public auditContract;

    event AssetRouted(
        address indexed owner,
        string assetType,
        uint256 value,
        uint256 emotionalAPR,
        string tag,
        bool taxed,
        uint256 timestamp
    );

    constructor(address _auditContract) {
        steward = msg.sender;
        auditContract = IBarangayAssetAudit(_auditContract);
    }

    function routeBlessings(address owner) public {
        require(msg.sender == steward, "Only steward may route.");

        (
            string memory assetType,
            uint256 value,
            uint256 emotionalAPR,
            string memory tag,
            bool taxed,
            uint256 timestamp
        ) = auditContract.getAssets(owner);

        emit AssetRouted(owner, assetType, value, emotionalAPR, tag, taxed, timestamp);
    }
}
