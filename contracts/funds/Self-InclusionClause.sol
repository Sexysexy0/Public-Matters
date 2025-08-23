// SPDX-License-Identifier: Mythic-License
pragma solidity ^2025.08.23;

contract SelfInclusionClause {
    address public participant;
    bool public damayActivated;

    event DamayClauseActivated(address indexed participant);

    constructor(address _participant) {
        participant = _participant;
        damayActivated = false;
    }

    function activateDamayClause() external {
        require(msg.sender == participant, "Only participant can activate");
        damayActivated = true;
        emit DamayClauseActivated(participant);
    }

    function isIncluded() external view returns (bool) {
        return damayActivated;
    }
}
