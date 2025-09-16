// SPDX-License-Identifier: WormSanctum
pragma solidity ^0.8.19;

contract WormGPTContainmentRouter {
    struct ThreatSignal {
        string modelAlias;
        string exploitType;
        bool contained;
        string stewardNote;
    }

    mapping(string => ThreatSignal) public threatRegistry;

    event ThreatTagged(string modelAlias, string exploitType);
    event ContainmentActivated(string modelAlias);

    function tagThreat(string memory modelAlias, string memory exploitType, string memory stewardNote) public {
        threatRegistry[modelAlias] = ThreatSignal(modelAlias, exploitType, false, stewardNote);
        emit ThreatTagged(modelAlias, exploitType);
    }

    function activateContainment(string memory modelAlias) public {
        require(bytes(threatRegistry[modelAlias].exploitType).length > 0, "Threat not tagged");
        threatRegistry[modelAlias].contained = true;
        emit ContainmentActivated(modelAlias);
    }

    function getThreatStatus(string memory modelAlias) public view returns (ThreatSignal memory) {
        return threatRegistry[modelAlias];
    }
}
