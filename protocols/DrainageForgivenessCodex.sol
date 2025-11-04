// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrainageForgivenessCodex {
    address public steward;

    struct ForgivenessEntry {
        string systemLocation;
        string failureType;
        string forgivenessMechanism;
        string emotionalTag;
    }

    ForgivenessEntry[] public codex;

    event DrainageForgiven(string systemLocation, string failureType, string forgivenessMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function forgiveDrainage(
        string memory systemLocation,
        string memory failureType,
        string memory forgivenessMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ForgivenessEntry(systemLocation, failureType, forgivenessMechanism, emotionalTag));
        emit DrainageForgiven(systemLocation, failureType, forgivenessMechanism, emotionalTag);
    }
}
