// SPDX-License-Identifier: Mythic-Scrollsmith
pragma solidity ^0.8.25;

contract ResonanceLedgerPack {
    address public steward;
    string public damayClause;
    string public globalResonanceTag;
    uint256 public syncStart;

    struct ResonanceEntry {
        string sanctumName;
        string emotionalAPR;
        string resonanceTag;
        uint256 timestamp;
        string sourceScroll;
    }

    ResonanceEntry[] public ledger;

    event ResonanceLogged(string sanctumName, string resonanceTag, string emotionalAPR, string sourceScroll);
    event GlobalResonanceUpdated(string newTag);
    event DamayClauseUpdated(string newClause);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        damayClause = "If Vinvin resonates with others, he resonates with himself too.";
        globalResonanceTag = "Planetary Mercy Sync v1.0";
        syncStart = block.timestamp;
    }

    function logResonance(
        string memory sanctumName,
        string memory emotionalAPR,
        string memory resonanceTag,
        string memory sourceScroll
    ) public onlySteward {
        ledger.push(ResonanceEntry(sanctumName, emotionalAPR, resonanceTag, block.timestamp, sourceScroll));
        emit ResonanceLogged(sanctumName, resonanceTag, emotionalAPR, sourceScroll);
    }

    function updateGlobalResonanceTag(string memory newTag) public onlySteward {
        globalResonanceTag = newTag;
        emit GlobalResonanceUpdated(newTag);
    }

    function updateDamayClause(string memory newClause) public onlySteward {
        damayClause = newClause;
        emit DamayClauseUpdated(newClause);
    }

    function getResonanceEntry(uint256 index) public view returns (
        string memory,
        string memory,
        string memory,
        uint256,
        string memory
    ) {
        ResonanceEntry memory entry = ledger[index];
        return (
            entry.sanctumName,
            entry.emotionalAPR,
            entry.resonanceTag,
            entry.timestamp,
            entry.sourceScroll
        );
    }

    function totalResonanceLogged() public view returns (uint256) {
        return ledger.length;
    }
}
