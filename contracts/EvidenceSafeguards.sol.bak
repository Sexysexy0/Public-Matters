// EvidenceSafeguards.sol
pragma solidity ^0.8.0;

contract EvidenceSafeguards {
    struct Record {
        uint256 id;
        string type;       // e.g. "Bank Records"
        string safeguard;  // e.g. "Ensure admissibility and integrity of records"
        uint256 timestamp;
    }

    uint256 public recordCount;
    mapping(uint256 => Record) public records;

    event RecordLogged(uint256 id, string type, string safeguard);

    function logRecord(string memory type, string memory safeguard) public {
        recordCount++;
        records[recordCount] = Record(recordCount, type, safeguard, block.timestamp);
        emit RecordLogged(recordCount, type, safeguard);
    }
}
