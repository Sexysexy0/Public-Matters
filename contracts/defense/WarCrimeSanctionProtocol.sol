// SPDX-License-Identifier: WarCrimeSanction-License
pragma solidity ^0.8.0;

contract WarCrimeSanctionProtocol {
    address public steward;

    struct WarCrimeCase {
        string perpetrator;
        string location;
        string civilianTarget;
        string weaponUsed;
        string verdict;
        uint256 timestamp;
    }

    WarCrimeCase[] public cases;

    event WarCrimeSanctionLogged(string perpetrator, string location, string target, string weapon, string verdict, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logWarCrime(
        string memory perpetrator,
        string memory location,
        string memory civilianTarget,
        string memory weaponUsed,
        string memory verdict
    ) public {
        require(msg.sender == steward, "Only steward can log");
        cases.push(WarCrimeCase(perpetrator, location, civilianTarget, weaponUsed, verdict, block.timestamp));
        emit WarCrimeSanctionLogged(perpetrator, location, civilianTarget, weaponUsed, verdict, block.timestamp);
    }

    function getCase(uint index) public view returns (string memory, string memory, string memory, string memory, string memory, uint256) {
        WarCrimeCase memory c = cases[index];
        return (c.perpetrator, c.location, c.civilianTarget, c.weaponUsed, c.verdict, c.timestamp);
    }
}
