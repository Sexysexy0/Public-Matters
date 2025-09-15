// SPDX-License-Identifier: GovernanceSanctum
pragma solidity ^0.8.19;

contract ProtocolVetoLedger {
    struct VetoEvent {
        string protocolName;
        string developerName;
        string vetoReason;
        bool communityConsensus;
        bool forkRisk;
        string impactSummary;
        bool civilReviewComplete;
    }

    mapping(bytes32 => VetoEvent) public vetoes;

    event VetoTagged(string protocolName, string developerName);
    event CivilReviewCompleted(string protocolName);

    function tagVeto(string memory protocolName, string memory developerName, string memory vetoReason, bool communityConsensus, bool forkRisk, string memory impactSummary) public {
        bytes32 vetoId = keccak256(abi.encodePacked(protocolName, developerName, block.timestamp));
        vetoes[vetoId] = VetoEvent(protocolName, developerName, vetoReason, communityConsensus, forkRisk, impactSummary, false);
        emit VetoTagged(protocolName, developerName);
    }

    function completeCivilReview(string memory protocolName, string memory developerName) public {
        bytes32 vetoId = keccak256(abi.encodePacked(protocolName, developerName, block.timestamp));
        vetoes[vetoId].civilReviewComplete = true;
        emit CivilReviewCompleted(protocolName);
    }

    function getVetoStatus(string memory protocolName, string memory developerName) public view returns (VetoEvent memory) {
        bytes32 vetoId = keccak256(abi.encodePacked(protocolName, developerName, block.timestamp));
        return vetoes[vetoId];
    }
}
