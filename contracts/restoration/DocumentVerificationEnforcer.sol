// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DocumentVerificationEnforcer {
    struct Document {
        string docHash; // IPFS or SHA256 hash of the document
        string signerName;
        string signerID; // e.g. TIN, Barangay ID, Passport No.
        bool isVerified;
        bool isForged;
        string verificationMethod; // e.g. "Biometric", "Notary", "BlockchainSig"
        string emotionalTag;
        uint256 timestamp;
    }

    Document[] public documents;

    event DocumentLogged(string docHash, string signerName, bool isVerified, bool isForged, string emotionalTag);

    function logDocument(
        string memory _docHash,
        string memory _signerName,
        string memory _signerID,
        bool _isVerified,
        bool _isForged,
        string memory _verificationMethod,
        string memory _emotionalTag
    ) public {
        documents.push(Document(_docHash, _signerName, _signerID, _isVerified, _isForged, _verificationMethod, _emotionalTag, block.timestamp));
        emit DocumentLogged(_docHash, _signerName, _isVerified, _isForged, _emotionalTag);
    }

    function getDocument(uint256 index) public view returns (Document memory) {
        return documents[index];
    }

    function totalDocuments() public view returns (uint256) {
        return documents.length;
    }
}
