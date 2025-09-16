// SPDX-License-Identifier: RansomwareSanctum
pragma solidity ^0.8.19;

contract RansomwareThreatSanctifier {
    struct ThreatSignal {
        string malwareName;
        string payloadType;
        string encryptionMethod;
        string extortionVector;
        bool verified;
        string stewardNote;
    }

    mapping(string => ThreatSignal) public threatRegistry;

    event ThreatTagged(string malwareName, string payloadType);
    event ThreatVerified(string malwareName);

    function tagThreat(string memory malwareName, string memory payloadType, string memory encryptionMethod, string memory extortionVector, string memory stewardNote) public {
        threatRegistry[malwareName] = ThreatSignal(malwareName, payloadType, encryptionMethod, extortionVector, false, stewardNote);
        emit ThreatTagged(malwareName, payloadType);
    }

    function verifyThreat(string memory malwareName) public {
        require(bytes(threatRegistry[malwareName].payloadType).length > 0, "Threat not tagged");
        threatRegistry[malwareName].verified = true;
        emit ThreatVerified(malwareName);
    }

    function getThreatStatus(string memory malwareName) public view returns (ThreatSignal memory) {
        return threatRegistry[malwareName];
    }
}
