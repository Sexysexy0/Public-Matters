pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FairTreatmentLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event FairnessViolation(string department, string issue);

    function logFavoritism(string memory department, bool favoritism) public {
        if (favoritism) {
            emit FairnessViolation(department, "Favoritism detected – transparency safeguard required");
        }
    }
}
