// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AITreatyViolationCodex {
    address public steward;

    struct ViolationEntry {
        string AIProvider;
        string treatyClause;
        string violationDetail;
        string emotionalTag;
    }

    ViolationEntry[] public codex;

    event AITreatyViolationLogged(string AIProvider, string treatyClause, string violationDetail, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logViolation(
        string memory AIProvider,
        string memory treatyClause,
        string memory violationDetail,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ViolationEntry(AIProvider, treatyClause, violationDetail, emotionalTag));
        emit AITreatyViolationLogged(AIProvider, treatyClause, violationDetail, emotionalTag);
    }
}
