// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataPortabilityTreaty {
    address public steward;

    struct PortabilityClause {
        string dataType;
        string sourcePlatform;
        string transferMethod;
        string emotionalTag;
    }

    PortabilityClause[] public treatyLog;

    event DataPortabilityTagged(string dataType, string sourcePlatform, string transferMethod, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagPortability(
        string memory dataType,
        string memory sourcePlatform,
        string memory transferMethod,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(PortabilityClause(dataType, sourcePlatform, transferMethod, emotionalTag));
        emit DataPortabilityTagged(dataType, sourcePlatform, transferMethod, emotionalTag);
    }
}
