// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFiSovereigntyDAO {
    address public steward;

    struct SovereigntyEntry {
        string protocolName;
        string decentralizationLevel;
        string exploitHistory;
        string emotionalTag;
    }

    SovereigntyEntry[] public registry;

    event DeFiSovereigntyTagged(string protocolName, string decentralizationLevel, string exploitHistory, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSovereignty(
        string memory protocolName,
        string memory decentralizationLevel,
        string memory exploitHistory,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(SovereigntyEntry(protocolName, decentralizationLevel, exploitHistory, emotionalTag));
        emit DeFiSovereigntyTagged(protocolName, decentralizationLevel, exploitHistory, emotionalTag);
    }
}
