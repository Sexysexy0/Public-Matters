// TransparencyCommonsDAO.sol
pragma solidity ^0.8.0;

contract TransparencyCommonsDAO {
    struct Record {
        uint256 id;
        string subject;   // e.g. "Financial Statement", "Governance Report"
        string details;
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public recordCount;
    mapping(uint256 => Record) public records;

    event RecordCreated(uint256 id, string subject, string details);
    event RecordVoted(uint256 id, string subject, bool support);
    event RecordPublished(uint256 id, string subject);
    event TransparencyDeclared(string message);

    function createRecord(string memory subject, string memory details) public {
        recordCount++;
        records[recordCount] = Record(recordCount, subject, details, 0, 0, false);
        emit RecordCreated(recordCount, subject, details);
    }

    function voteRecord(uint256 id, bool support) public {
        if (support) {
            records[id].votesFor++;
        } else {
            records[id].votesAgainst++;
        }
        emit RecordVoted(id, records[id].subject, support);
    }

    function publishRecord(uint256 id) public {
        Record storage r = records[id];
        require(!r.published, "Already published");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.published = true;
        emit RecordPublished(r.id, r.subject);
    }

    function declareTransparency() public {
        emit TransparencyDeclared("Transparency Commons DAO: openness arcs encoded into communal consequence.");
    }
}
