// CitizenLedgerDAO.sol
pragma solidity ^0.8.0;

contract CitizenLedgerDAO {
    struct Entry {
        uint256 id;
        string citizen;   // e.g. "Household"
        string issue;     // e.g. "High utility bill"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public entryCount;
    mapping(uint256 => Entry) public entries;

    event EntryCreated(uint256 id, string citizen, string issue);
    event EntryVoted(uint256 id, string citizen, bool support);
    event EntryResolved(uint256 id, string citizen);
    event LedgerDeclared(string message);

    function createEntry(string memory citizen, string memory issue) public {
        entryCount++;
        entries[entryCount] = Entry(entryCount, citizen, issue, 0, 0, false);
        emit EntryCreated(entryCount, citizen, issue);
    }

    function voteEntry(uint256 id, bool support) public {
        if (support) {
            entries[id].votesFor++;
        } else {
            entries[id].votesAgainst++;
        }
        emit EntryVoted(id, entries[id].citizen, support);
    }

    function resolveEntry(uint256 id) public {
        Entry storage e = entries[id];
        require(!e.resolved, "Already resolved");
        require(e.votesFor > e.votesAgainst, "Not enough support");
        e.resolved = true;
        emit EntryResolved(e.id, e.citizen);
    }

    function declareLedger() public {
        emit LedgerDeclared("Citizen Ledger DAO: safeguard arcs encoded into communal consequence.");
    }
}
