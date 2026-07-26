pragma solidity ^0.8.0;

contract JusticeBalanceProtocol {
    event JusticeAlert(string group, string outcome);

    function recordOutcome(string memory group, string memory outcome) public {
        emit JusticeAlert(group, outcome);
    }
}
