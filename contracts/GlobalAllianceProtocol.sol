pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GlobalAllianceProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event AllianceActivation(string partners, string issue);

    function activateAlliance(string memory partners, bool crisis) public {
        if (crisis) {
            emit AllianceActivation(partners, "Global crisis detected – alliance safeguard activated");
        }
    }
}
