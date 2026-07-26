// JusticeProtocol.sol
pragma solidity ^0.8.0;

contract JusticeProtocol {
    struct Case {
        uint256 id;
        string domain;       // e.g. "Human Rights"
        string description;  // e.g. "Fair trial enforcement"
        bool resolved;
        uint256 timestamp;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseResolved(uint256 id, string domain, string description);

    function resolveCase(string memory domain, string memory description) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, domain, description, true, block.timestamp);
        emit CaseResolved(caseCount, domain, description);
    }
}
