// SPDX-License-Identifier: MIT
// Contract Name: CreativeRightsCovenant
// Purpose: Encode systemic safeguards for intellectual property ownership, royalties, and fair licensing
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CreativeRightsCovenant {
    address public chiefOperator;

    struct RightsRecord {
        string principle;   // e.g. IP ownership, Royalties, Fair licensing
        string mechanism;   // e.g. Licensing contracts, Royalty splits, IP registry
        string sector;      // e.g. Gaming, Marketplace, Creative industry
        string outcome;     // e.g. Ownership upheld, Royalties distributed, Licensing fairness achieved
        uint256 timestamp;
    }

    RightsRecord[] public records;

    event RightsLogged(string principle, string mechanism, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logRights(
        string memory principle,
        string memory mechanism,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(RightsRecord(principle, mechanism, sector, outcome, block.timestamp));
        emit RightsLogged(principle, mechanism, sector, outcome, block.timestamp);
    }

    function getRights(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid rights index");
        RightsRecord memory rr = records[index];
        return (rr.principle, rr.mechanism, rr.sector, rr.outcome, rr.timestamp);
    }
}
