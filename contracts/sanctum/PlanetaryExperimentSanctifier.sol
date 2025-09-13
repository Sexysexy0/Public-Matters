// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryExperimentSanctifier {
    enum ExperimentType { ClimateRestoration, BiomeRebalancing, Terraforming, EcologicalAdaptation }
    enum BlessingOutcome { Success, Partial, Mutation, Beauty }

    struct Sanctification {
        uint256 id;
        ExperimentType experimentType;
        BlessingOutcome outcome;
        string planetTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => Sanctification) public sanctumRegistry;
    uint256 public sanctumCount;

    event SanctificationLogged(uint256 id, ExperimentType experimentType, BlessingOutcome outcome);
    event OutcomeUpdated(uint256 id, BlessingOutcome newOutcome);

    function logSanctification(
        ExperimentType experimentType,
        BlessingOutcome outcome,
        string memory planetTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        sanctumRegistry[sanctumCount] = Sanctification(
            sanctumCount,
            experimentType,
            outcome,
            planetTag,
            clauseReference,
            timestamp
        );
        emit SanctificationLogged(sanctumCount, experimentType, outcome);
        sanctumCount++;
    }

    function updateOutcome(uint256 id, BlessingOutcome newOutcome) public {
        require(id < sanctumCount, "Invalid sanctification ID");
        sanctumRegistry[id].outcome = newOutcome;
        emit OutcomeUpdated(id, newOutcome);
    }

    function getSanctification(uint256 id) public view returns (Sanctification memory) {
        return sanctumRegistry[id];
    }
}
