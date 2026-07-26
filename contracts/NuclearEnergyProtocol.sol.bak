pragma solidity ^0.8.0;

contract NuclearEnergyProtocol {
    event NuclearAdoptionAlert(string country, string issue);

    function adoptNuclear(string memory country, bool crisis) public {
        if (crisis) {
            emit NuclearAdoptionAlert(country, "Energy crisis detected – nuclear adoption safeguard activated");
        }
    }
}
