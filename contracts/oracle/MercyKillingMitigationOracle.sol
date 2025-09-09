// SPDX-License-Identifier: PenalMercy-License
pragma solidity ^0.8.0;

contract MercyKillingMitigationOracle {
    address public steward;

    struct MercyCase {
        string accused;
        string victim;
        string mitigatingFactor;
        string adjustedVerdict;
        uint256 timestamp;
    }

    MercyCase[] public cases;

    event MercyVerdictEmitted(string accused, string victim, string factor, string verdict, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logMercyCase(string memory accused, string memory victim, string memory mitigatingFactor) public {
        require(msg.sender == steward, "Only steward can log");
        string memory verdict = keccak256(bytes(mitigatingFactor)) == keccak256(bytes("Incomplete Self-Defense")) ? "Reclusion Temporal" : "Reclusion Perpetua";
        cases.push(MercyCase(accused, victim, mitigatingFactor, verdict, block.timestamp));
        emit MercyVerdictEmitted(accused, victim, mitigatingFactor, verdict, block.timestamp);
    }

    function getCase(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        MercyCase memory c = cases[index];
        return (c.accused, c.victim, c.mitigatingFactor, c.adjustedVerdict, c.timestamp);
    }
}
