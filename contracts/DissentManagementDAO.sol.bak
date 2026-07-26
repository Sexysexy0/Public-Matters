// DissentManagementDAO.sol
pragma solidity ^0.8.0;

contract DissentManagementDAO {
    struct Case {
        uint256 id;
        string member;     // e.g. "Rep. Erice"
        string issue;      // e.g. "Criticism of Anti-Political Dynasty Bill"
        string resolution; // e.g. "Debate logged, leadership reshuffle"
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseResolved(uint256 id, string member, string resolution);

    function resolveCase(string memory member, string memory issue, string memory resolution) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, member, issue, resolution, true);
        emit CaseResolved(caseCount, member, resolution);
    }
}
