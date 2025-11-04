// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedCustodyUXTreaty {
    address public steward;

    struct UXClause {
        string custodyTool;
        string UXChallenge;
        string decentralizationSignal;
        string emotionalTag;
    }

    UXClause[] public treatyLog;

    event CustodyUXTagged(string custodyTool, string UXChallenge, string decentralizationSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagUX(
        string memory custodyTool,
        string memory UXChallenge,
        string memory decentralizationSignal,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(UXClause(custodyTool, UXChallenge, decentralizationSignal, emotionalTag));
        emit CustodyUXTagged(custodyTool, UXChallenge, decentralizationSignal, emotionalTag);
    }
}
