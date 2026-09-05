// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccountabilityContract {
    struct Case {
        uint256 id;
        address offender;
        bool mentalHealthFlag;
        bool resolved;
        uint256 penalty;
    }

    mapping(uint256 => Case) public cases;
    uint256 public caseCounter;

    event CaseFiled(uint256 indexed id, address offender);
    event CaseResolved(uint256 indexed id, uint256 penalty);

    function fileCase(address offender, bool mentalHealthFlag) external {
        caseCounter++;
        cases[caseCounter] = Case(caseCounter, offender, mentalHealthFlag, false, 0);
        emit CaseFiled(caseCounter, offender);
    }

    function resolveCase(uint256 id, uint256 penalty) external {
        require(!cases[id].resolved, "Already resolved");
        cases[id].resolved = true;
        cases[id].penalty = penalty;
        emit CaseResolved(id, penalty);
    }
}
