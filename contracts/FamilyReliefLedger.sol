pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FamilyReliefLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EquityAlert(string family, string issue);

    function checkInclusion(string memory family, bool included) public {
        if (!included) {
            emit EquityAlert(family, "Family excluded – relief safeguard required");
        }
    }
}
