// TransparencyProtocol.sol
pragma solidity ^0.8.0;

contract TransparencyProtocol {
    struct Record {
        uint256 id;
        string session;   // e.g. "House Plenary Debate"
        string detail;    // e.g. "Vote count published"
        uint256 timestamp;
    }

    uint256 public recordCount;
    mapping(uint256 => Record) public records;

    event RecordLogged(uint256 id, string session, string detail);

    function logRecord(string memory session, string memory detail) public {
        recordCount++;
        records[recordCount] = Record(recordCount, session, detail, block.timestamp);
        emit RecordLogged(recordCount, session, detail);
    }
}
