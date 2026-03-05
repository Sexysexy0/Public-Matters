// TreatyGrantProtocol.sol
pragma solidity ^0.8.0;

contract TreatyGrantProtocol {
    struct Clause {
        uint256 id;
        string demand;       // e.g. "Lift sanctions"
        string status;       // e.g. "Granted"
        uint256 timestamp;
    }

    uint256 public clauseCount;
    mapping(uint256 => Clause) public clauses;

    event ClauseGranted(uint256 id, string demand, string status);

    function grantClause(string memory demand, string memory status) public {
        clauseCount++;
        clauses[clauseCount] = Clause(clauseCount, demand, status, block.timestamp);
        emit ClauseGranted(clauseCount, demand, status);
    }
}
