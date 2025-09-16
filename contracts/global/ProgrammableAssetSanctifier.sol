// SPDX-License-Identifier: AssetSanctum
pragma solidity ^0.8.19;

contract ProgrammableAssetSanctifier {
    struct AssetSignal {
        string assetID;
        string assetType;
        string jurisdiction;
        bool programmable;
        bool verifiedCompliant;
        string stewardNote;
    }

    mapping(string => AssetSignal) public assetRegistry;

    event AssetTagged(string assetID, string assetType);
    event ComplianceVerified(string assetID);

    function tagAsset(string memory assetID, string memory assetType, string memory jurisdiction, bool programmable, string memory stewardNote) public {
        assetRegistry[assetID] = AssetSignal(assetID, assetType, jurisdiction, programmable, false, stewardNote);
        emit AssetTagged(assetID, assetType);
    }

    function verifyCompliance(string memory assetID) public {
        require(bytes(assetRegistry[assetID].assetType).length > 0, "Asset not tagged");
        assetRegistry[assetID].verifiedCompliant = true;
        emit ComplianceVerified(assetID);
    }

    function getAssetStatus(string memory assetID) public view returns (AssetSignal memory) {
        return assetRegistry[assetID];
    }
}
