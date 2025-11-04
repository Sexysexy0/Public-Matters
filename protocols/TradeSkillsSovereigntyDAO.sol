// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TradeSkillsSovereigntyDAO {
    address public steward;

    struct SkillEntry {
        string tradeSkill;
        string sovereigntySignal;
        string trainingPath;
        string emotionalTag;
    }

    SkillEntry[] public registry;

    event TradeSkillTagged(string tradeSkill, string sovereigntySignal, string trainingPath, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagTradeSkill(
        string memory tradeSkill,
        string memory sovereigntySignal,
        string memory trainingPath,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(SkillEntry(tradeSkill, sovereigntySignal, trainingPath, emotionalTag));
        emit TradeSkillTagged(tradeSkill, sovereigntySignal, trainingPath, emotionalTag);
    }
}
