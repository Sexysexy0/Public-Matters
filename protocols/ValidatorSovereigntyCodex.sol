// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValidatorSovereigntyCodex {
    address public steward;

    struct SovereigntyEntry {
        string chainName;
        string validatorAction;
        string decentralizationImpact;
        string emotionalTag;
    }

    SovereigntyEntry[] public codex;

    event ValidatorSovereigntyLogged(string chainName, string validatorAction, string decentralizationImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logSovereignty(
        string memory chainName,
        string memory validatorAction,
        string memory decentralizationImpact,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(SovereigntyEntry(chainName, validatorAction, decentralizationImpact, emotionalTag));
        emit ValidatorSovereigntyLogged(chainName, validatorAction, decentralizationImpact, emotionalTag);
    }
}
