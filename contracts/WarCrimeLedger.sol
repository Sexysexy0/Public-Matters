pragma solidity ^0.8.0;

contract WarCrimeLedger {
    event WarCrimeEntry(string violator, string article);

    function recordViolation(string memory violator, string memory article) public {
        emit WarCrimeEntry(violator, article);
    }
}
