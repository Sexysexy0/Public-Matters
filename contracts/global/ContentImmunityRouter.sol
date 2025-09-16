// SPDX-License-Identifier: ImmunitySanctum
pragma solidity ^0.8.19;

contract ContentImmunityRouter {
    struct ImmunitySignal {
        string contentHash;
        string creatorID;
        string immunityType; // e.g. "Royalty-Protected", "Cultural Artifact", "Diplomatic Exemption"
        bool verified;
        string stewardNote;
    }

    mapping(string => ImmunitySignal) public immunityRegistry;

    event ContentTagged(string contentHash, string immunityType);
    event ImmunityVerified(string contentHash);

    function tagContent(string memory contentHash, string memory creatorID, string memory immunityType, string memory stewardNote) public {
        immunityRegistry[contentHash] = ImmunitySignal(contentHash, creatorID, immunityType, false, stewardNote);
        emit ContentTagged(contentHash, immunityType);
    }

    function verifyImmunity(string memory contentHash) public {
        require(bytes(immunityRegistry[contentHash].creatorID).length > 0, "Content not tagged");
        immunityRegistry[contentHash].verified = true;
        emit ImmunityVerified(contentHash);
    }

    function getImmunityStatus(string memory contentHash) public view returns (ImmunitySignal memory) {
        return immunityRegistry[contentHash];
    }
}
