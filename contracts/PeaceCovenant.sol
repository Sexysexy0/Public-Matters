// SPDX-License-Identifier: MIT
// Contract Name: PeaceCovenant
// Purpose: Encode peace + non-escalation principles in governance
// Source: Grounded in Public Matters vision (peace, unity, fairness, dignity)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract PeaceCovenant {
    address public chiefOperator;

    struct PeaceRecord {
        string principle;   // e.g. Peace, Non-escalation, Balance
        string action;      // e.g. Mediation, Conflict prevention, Equilibrium safeguard
        string sector;      // e.g. Telecom, Finance, Utilities, Education
        string outcome;     // e.g. Peace upheld, Balance achieved, Stability reinforced
        uint256 timestamp;
    }

    PeaceRecord[] public records;

    event PeaceLogged(string principle, string action, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logPeace(
        string memory principle,
        string memory action,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(PeaceRecord(principle, action, sector, outcome, block.timestamp));
        emit PeaceLogged(principle, action, sector, outcome, block.timestamp);
    }

    function getPeace(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid peace index");
        PeaceRecord memory pr = records[index];
        return (pr.principle, pr.action, pr.sector, pr.outcome, pr.timestamp);
    }
}
