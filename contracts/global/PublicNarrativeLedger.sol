// SPDX-License-Identifier: NarrativeSanctum
pragma solidity ^0.8.19;

contract PublicNarrativeLedger {
    struct NarrativeSignal {
        string signalID;
        string originSource;
        string narrativeTheme;
        bool verified;
        string stewardNote;
    }

    mapping(string => NarrativeSignal) public narrativeRegistry;

    event NarrativeTagged(string signalID, string narrativeTheme);
    event NarrativeSanctified(string signalID);

    function tagNarrative(string memory signalID, string memory originSource, string memory narrativeTheme, string memory stewardNote) public {
        narrativeRegistry[signalID] = NarrativeSignal(signalID, originSource, narrativeTheme, false, stewardNote);
        emit NarrativeTagged(signalID, narrativeTheme);
    }

    function sanctifyNarrative(string memory signalID) public {
        require(bytes(narrativeRegistry[signalID].originSource).length > 0, "Origin not tagged");
        narrativeRegistry[signalID].verified = true;
        emit NarrativeSanctified(signalID);
    }

    function getNarrativeStatus(string memory signalID) public view returns (NarrativeSignal memory) {
        return narrativeRegistry[signalID];
    }
}
