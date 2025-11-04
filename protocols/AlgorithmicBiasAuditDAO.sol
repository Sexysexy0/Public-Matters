// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlgorithmicBiasAuditDAO {
    address public steward;

    struct BiasEntry {
        string algorithmName;
        string biasType;
        string affectedGroup;
        string emotionalTag;
    }

    BiasEntry[] public registry;

    event AlgorithmicBiasTagged(string algorithmName, string biasType, string affectedGroup, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagBias(
        string memory algorithmName,
        string memory biasType,
        string memory affectedGroup,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(BiasEntry(algorithmName, biasType, affectedGroup, emotionalTag));
        emit AlgorithmicBiasTagged(algorithmName, biasType, affectedGroup, emotionalTag);
    }
}
