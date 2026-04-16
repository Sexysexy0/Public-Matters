pragma solidity ^0.8.0;

contract FairTreatmentLedger {
    event FairnessViolation(string department, string issue);

    function logFavoritism(string memory department, bool favoritism) public {
        if (favoritism) {
            emit FairnessViolation(department, "Favoritism detected – transparency safeguard required");
        }
    }
}
