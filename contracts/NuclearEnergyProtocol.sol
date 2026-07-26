pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NuclearEnergyProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event NuclearAdoptionAlert(string country, string issue);

    function adoptNuclear(string memory country, bool crisis) public {
        if (crisis) {
            emit NuclearAdoptionAlert(country, "Energy crisis detected – nuclear adoption safeguard activated");
        }
    }
}
