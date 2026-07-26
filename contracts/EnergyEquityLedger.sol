pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EnergyEquityLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EquityAlert(string sector, string issue);

    function checkInclusion(string memory sector, bool included) public {
        if (!included) {
            emit EquityAlert(sector, "Sector excluded – energy inclusion safeguard required");
        }
    }
}
