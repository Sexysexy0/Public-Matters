// SPDX-License-Identifier: KIGSanctum
pragma solidity ^0.8.19;

contract KalayaanIslandGroupSanctifier {
    struct IslandFeature {
        string featureID;
        string localName;
        string patrolUnit;
        bool sovereigntyAsserted;
        string stewardNote;
    }

    mapping(string => IslandFeature) public kigRegistry;

    event FeatureTagged(string featureID, string localName);
    event SovereigntySanctified(string featureID);

    function tagFeature(string memory featureID, string memory localName, string memory patrolUnit, string memory stewardNote) public {
        kigRegistry[featureID] = IslandFeature(featureID, localName, patrolUnit, false, stewardNote);
        emit FeatureTagged(featureID, localName);
    }

    function sanctifySovereignty(string memory featureID) public {
        require(bytes(kigRegistry[featureID].localName).length > 0, "Feature not tagged");
        kigRegistry[featureID].sovereigntyAsserted = true;
        emit SovereigntySanctified(featureID);
    }

    function getFeatureStatus(string memory featureID) public view returns (IslandFeature memory) {
        return kigRegistry[featureID];
    }
}
