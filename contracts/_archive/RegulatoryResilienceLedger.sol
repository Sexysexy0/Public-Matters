pragma solidity ^0.8.0;

contract RegulatoryResilienceLedger {
    event ResilienceAlert(string company, string issue);

    function logEvent(string memory company, string memory issue) public {
        emit ResilienceAlert(company, issue);
    }
}
