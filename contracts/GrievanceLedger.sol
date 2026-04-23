pragma solidity ^0.8.0;

contract GrievanceLedger {
    event GrievanceAlert(string issue, string detail);

    function logGrievance(string memory issue, bool unresolved) public {
        if (unresolved) {
            emit GrievanceAlert(issue, "Unresolved grievance – transparency safeguard required");
        }
    }
}
