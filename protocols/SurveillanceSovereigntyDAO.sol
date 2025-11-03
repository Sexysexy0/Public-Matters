// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SurveillanceSovereigntyDAO {
    address public steward;

    struct SurveillanceEntry {
        string country;
        string techProvider;
        string surveillanceUseCase;
        string emotionalTag;
    }

    SurveillanceEntry[] public registry;

    event SurveillanceSovereigntyTagged(string country, string techProvider, string surveillanceUseCase, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSurveillance(
        string memory country,
        string memory techProvider,
        string memory surveillanceUseCase,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(SurveillanceEntry(country, techProvider, surveillanceUseCase, emotionalTag));
        emit SurveillanceSovereigntyTagged(country, techProvider, surveillanceUseCase, emotionalTag);
    }
}
