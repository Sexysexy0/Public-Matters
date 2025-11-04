// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GenZLaborEquityCodex {
    address public steward;

    struct EquityEntry {
        string laborSector;
        string equitySignal;
        string youthMechanism;
        string emotionalTag;
    }

    EquityEntry[] public codex;

    event GenZLaborEquityTagged(string laborSector, string equitySignal, string youthMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagEquity(
        string memory laborSector,
        string memory equitySignal,
        string memory youthMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(EquityEntry(laborSector, equitySignal, youthMechanism, emotionalTag));
        emit GenZLaborEquityTagged(laborSector, equitySignal, youthMechanism, emotionalTag);
    }
}
