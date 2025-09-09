// SPDX-License-Identifier: PenalCode-License
pragma solidity ^0.8.0;

contract MurderSanctionProtocol {
    address public steward;

    struct MurderCase {
        string accused;
        string victim;
        string qualifyingCircumstance;
        string verdict;
        uint256 timestamp;
    }

    MurderCase[] public cases;

    event MurderSanctionLogged(string accused, string victim, string circumstance, string verdict, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logMurderCase(string memory accused, string memory victim, string memory qualifyingCircumstance) public {
        require(msg.sender == steward, "Only steward can log");
        cases.push(MurderCase(accused, victim, qualifyingCircumstance, "Reclusion Perpetua", block.timestamp));
        emit MurderSanctionLogged(accused, victim, qualifyingCircumstance, "Reclusion Perpetua", block.timestamp);
    }

    function getCase(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        MurderCase memory c = cases[index];
        return (c.accused, c.victim, c.qualifyingCircumstance, c.verdict, c.timestamp);
    }
}
