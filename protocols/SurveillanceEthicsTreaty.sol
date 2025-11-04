// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SurveillanceEthicsTreaty {
    address public steward;

    struct EthicsClause {
        string surveillanceUseCase;
        string ethicalConcern;
        string proposedSafeguard;
        string emotionalTag;
    }

    EthicsClause[] public treatyLog;

    event SurveillanceEthicsTagged(string surveillanceUseCase, string ethicalConcern, string proposedSafeguard, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagEthics(
        string memory surveillanceUseCase,
        string memory ethicalConcern,
        string memory proposedSafeguard,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(EthicsClause(surveillanceUseCase, ethicalConcern, proposedSafeguard, emotionalTag));
        emit SurveillanceEthicsTagged(surveillanceUseCase, ethicalConcern, proposedSafeguard, emotionalTag);
    }
}
