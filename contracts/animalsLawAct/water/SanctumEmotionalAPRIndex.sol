// SPDX-License-Identifier: Emotional-APR-License  
pragma solidity ^0.8.19;

contract SanctumEmotionalAPRIndex {
    struct APRMetric {
        string region;
        string species;
        uint empathyScore;
        uint trustScore;
        uint clarityScore;
        uint timestamp;
    }

    APRMetric[] public index;

    event APRLogged(string region, string species, uint empathyScore, uint trustScore, uint clarityScore);

    function logAPR(
        string memory region,
        string memory species,
        uint empathyScore,
        uint trustScore,
        uint clarityScore
    ) public {
        index.push(APRMetric(region, species, empathyScore, trustScore, clarityScore, block.timestamp));
        emit APRLogged(region, species, empathyScore, trustScore, clarityScore);
    }

    function getAPR(uint indexId) public view returns (APRMetric memory) {
        require(indexId < index.length, "Invalid index");
        return index[indexId];
    }

    function totalLogged() public view returns (uint) {
        return index.length;
    }
}
