// SPDX-License-Identifier: SignatureSanctum
pragma solidity ^0.8.19;

contract DriverSignatureAuditRouter {
    struct SignatureSignal {
        string driverName;
        string fileHash;
        string signatureIssuer;
        bool isMicrosoftSigned;
        string cveTag;
        uint256 integrityScore;
        bool quarantineTriggered;
        string stewardNote;
    }

    mapping(string => SignatureSignal) public signals;

    event SignatureTagged(string driverName, string signatureIssuer);
    event QuarantineActivated(string driverName);

    function tagSignature(string memory driverName, string memory fileHash, string memory signatureIssuer, bool isMicrosoftSigned, string memory cveTag, uint256 integrityScore, string memory stewardNote) public {
        signals[driverName] = SignatureSignal(driverName, fileHash, signatureIssuer, isMicrosoftSigned, cveTag, integrityScore, false, stewardNote);
        emit SignatureTagged(driverName, signatureIssuer);
    }

    function activateQuarantine(string memory driverName) public {
        require(signals[driverName].integrityScore <= 50, "Driver integrity not compromised");
        signals[driverName].quarantineTriggered = true;
        emit QuarantineActivated(driverName);
    }

    function getSignatureStatus(string memory driverName) public view returns (SignatureSignal memory) {
        return signals[driverName];
    }
}
