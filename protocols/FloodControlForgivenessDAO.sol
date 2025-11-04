// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlForgivenessDAO {
    address public steward;

    struct ForgivenessEntry {
        string projectLocation;
        string failureType;
        string forgivenessMechanism;
        string emotionalTag;
    }

    ForgivenessEntry[] public registry;

    event FloodControlForgiven(string projectLocation, string failureType, string forgivenessMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function forgiveFloodControl(
        string memory projectLocation,
        string memory failureType,
        string memory forgivenessMechanism,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ForgivenessEntry(projectLocation, failureType, forgivenessMechanism, emotionalTag));
        emit FloodControlForgiven(projectLocation, failureType, forgivenessMechanism, emotionalTag);
    }
}
