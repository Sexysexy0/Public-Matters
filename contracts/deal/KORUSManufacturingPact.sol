// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract KORUSManufacturingPact {
    struct TreatyClause {
        string clause;
        string techTransfer;
        string ancestralTag;
    }

    TreatyClause[] public clauses;

    function logClause(
        string memory _clause,
        string memory _techTransfer,
        string memory _ancestralTag
    ) public {
        clauses.push(TreatyClause(_clause, _techTransfer, _ancestralTag));
    }

    function getClause(uint index) public view returns (TreatyClause memory) {
        return clauses[index];
    }
}
