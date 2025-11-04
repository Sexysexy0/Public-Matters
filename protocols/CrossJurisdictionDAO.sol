// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrossJurisdictionDAO {
    address public steward;

    struct JurisdictionEntry {
        string protocolName;
        string jurisdictionA;
        string jurisdictionB;
        string conflictClause;
        string emotionalTag;
    }

    JurisdictionEntry[] public registry;

    event CrossJurisdictionTagged(string protocolName, string jurisdictionA, string jurisdictionB, string conflictClause, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagJurisdiction(
        string memory protocolName,
        string memory jurisdictionA,
        string memory jurisdictionB,
        string memory conflictClause,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(JurisdictionEntry(protocolName, jurisdictionA, jurisdictionB, conflictClause, emotionalTag));
        emit CrossJurisdictionTagged(protocolName, jurisdictionA, jurisdictionB, conflictClause, emotionalTag);
    }
}
