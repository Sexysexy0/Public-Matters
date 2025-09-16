// SPDX-License-Identifier: TruthSanctum
pragma solidity ^0.8.19;

contract TruthSignalRouter {
    struct TruthSignal {
        string contentHash;
        string creatorID;
        string verificationMethod;
        bool verified;
        string stewardNote;
    }

    mapping(string => TruthSignal) public truthRegistry;

    event ContentTagged(string contentHash, string creatorID);
    event TruthVerified(string contentHash);

    function tagContent(string memory contentHash, string memory creatorID, string memory verificationMethod, string memory stewardNote) public {
        truthRegistry[contentHash] = TruthSignal(contentHash, creatorID, verificationMethod, false, stewardNote);
        emit ContentTagged(contentHash, creatorID);
    }

    function verifyTruth(string memory contentHash) public {
        require(bytes(truthRegistry[contentHash].creatorID).length > 0, "Content not tagged");
        truthRegistry[contentHash].verified = true;
        emit TruthVerified(contentHash);
    }

    function getTruthStatus(string memory contentHash) public view returns (TruthSignal memory) {
        return truthRegistry[contentHash];
    }
}
