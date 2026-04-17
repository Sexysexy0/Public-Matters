pragma solidity ^0.8.0;

contract GlobalAllianceProtocol {
    event AllianceActivation(string partners, string issue);

    function activateAlliance(string memory partners, bool crisis) public {
        if (crisis) {
            emit AllianceActivation(partners, "Global crisis detected – alliance safeguard activated");
        }
    }
}
