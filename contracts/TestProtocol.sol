// TestProtocol.sol
pragma solidity ^0.8.0;

contract TestProtocol {
    struct Case {
        uint256 id;
        string domain;       // e.g. "Authentication"
        string description;  // e.g. "Unit test for login flow"
        bool passed;
        uint256 timestamp;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseLogged(uint256 id, string domain, string description, bool passed);

    function logCase(string memory domain, string memory description, bool passed) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, domain, description, passed, block.timestamp);
        emit CaseLogged(caseCount, domain, description, passed);
    }
}
