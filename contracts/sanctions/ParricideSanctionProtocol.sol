// SPDX-License-Identifier: ParricideSanction-License
pragma solidity ^0.8.0;

contract ParricideSanctionProtocol {
    address public steward;

    struct ParricideCase {
        string accused;
        string victim;
        string relationship;
        string mitigatingFactor;
        string verdict;
        uint256 timestamp;
    }

    ParricideCase[] public cases;

    event ParricideSanctionLogged(string accused, string victim, string relationship, string factor, string verdict, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logParricideCase(
        string memory accused,
        string memory victim,
        string memory relationship,
        string memory mitigatingFactor
    ) public {
        require(msg.sender == steward, "Only steward can log");
        string memory verdict = keccak256(bytes(mitigatingFactor)) == keccak256(bytes("Passion or Obfuscation"))
            ? "Reclusion Temporal"
            : "Reclusion Perpetua";
        cases.push(ParricideCase(accused, victim, relationship, mitigatingFactor, verdict, block.timestamp));
        emit ParricideSanctionLogged(accused, victim, relationship, mitigatingFactor, verdict, block.timestamp);
    }

    function getCase(uint index) public view returns (string memory, string memory, string memory, string memory, string memory, uint256) {
        ParricideCase memory c = cases[index];
        return (c.accused, c.victim, c.relationship, c.mitigatingFactor, c.verdict, c.timestamp);
    }
}
