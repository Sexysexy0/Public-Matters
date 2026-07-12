// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsLegitimacyCovenant
// Purpose: Encode recognition + authority outcomes as extension of trust
// Source: Grounded in Public Matters vision (legitimacy through trust, fairness, unity)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsLegitimacyCovenant {
    address public chiefOperator;

    struct LegitimacyRecord {
        string source;      // e.g. Trust, Equity, Governance coherence
        string recognition; // e.g. Stakeholder endorsement, Policy adoption, Community validation
        string authority;   // e.g. Governance body, Institution, Collective mandate
        string outcome;     // e.g. Legitimacy, Authority upheld, Systemic acceptance
        uint256 timestamp;
    }

    LegitimacyRecord[] public records;

    event LegitimacyLogged(string source, string recognition, string authority, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logLegitimacy(
        string memory source,
        string memory recognition,
        string memory authority,
        string memory outcome
    ) public onlyChief {
        records.push(LegitimacyRecord(source, recognition, authority, outcome, block.timestamp));
        emit LegitimacyLogged(source, recognition, authority, outcome, block.timestamp);
    }

    function getLegitimacy(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid legitimacy index");
        LegitimacyRecord memory lr = records[index];
        return (lr.source, lr.recognition, lr.authority, lr.outcome, lr.timestamp);
    }
}
