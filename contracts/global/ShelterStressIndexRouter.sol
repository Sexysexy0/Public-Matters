// SPDX-License-Identifier: ShelterSanctum
pragma solidity ^0.8.19;

contract ShelterStressIndexRouter {
    struct StressSignal {
        string region;
        uint256 housingCostBurden; // % of income spent on housing
        uint256 residualIncome;    // income left after housing costs
        bool stressVerified;
        string stewardNote;
    }

    mapping(string => StressSignal) public stressRegistry;

    event StressTagged(string region);
    event StressVerified(string region);

    function tagStress(string memory region, uint256 housingCostBurden, uint256 residualIncome, string memory stewardNote) public {
        stressRegistry[region] = StressSignal(region, housingCostBurden, residualIncome, false, stewardNote);
        emit StressTagged(region);
    }

    function verifyStress(string memory region) public {
        require(bytes(stressRegistry[region].region).length > 0, "Region not tagged");
        stressRegistry[region].stressVerified = true;
        emit StressVerified(region);
    }

    function getStressStatus(string memory region) public view returns (StressSignal memory) {
        return stressRegistry[region];
    }
}
