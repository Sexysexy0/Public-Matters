// SPDX-License-Identifier: NarrativeSanctum
pragma solidity ^0.8.19;

contract NarrativeEquityRouter {
    struct NarrativeSignal {
        string contentHash;
        string narrativeType; // e.g., "Educational", "Political", "Satirical", "Commercial"
        string jurisdiction;
        bool equityVerified;
        string stewardNote;
    }

    mapping(string => NarrativeSignal) public narrativeRegistry;

    event NarrativeTagged(string contentHash, string narrativeType);
    event EquityVerified(string contentHash);

    function tagNarrative(string memory contentHash, string memory narrativeType, string memory jurisdiction, string memory stewardNote) public {
        narrativeRegistry[contentHash] = NarrativeSignal(contentHash, narrativeType, jurisdiction, false, stewardNote);
        emit NarrativeTagged(contentHash, narrativeType);
    }

    function verifyEquity(string memory contentHash) public {
        require(bytes(narrativeRegistry[contentHash].narrativeType).length > 0, "Narrative not tagged");
        narrativeRegistry[contentHash].equityVerified = true;
        emit EquityVerified(contentHash);
    }

    function getNarrativeStatus(string memory contentHash) public view returns (NarrativeSignal memory) {
        return narrativeRegistry[contentHash];
    }
}
