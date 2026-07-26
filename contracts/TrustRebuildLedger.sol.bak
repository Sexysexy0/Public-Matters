pragma solidity ^0.8.0;

contract TrustRebuildLedger {
    event TrustAlert(string partners, string issue);

    function checkTrust(string memory partners, bool trustBuilt) public {
        if (!trustBuilt) {
            emit TrustAlert(partners, "Trust deficit detected – rebuild safeguard required");
        }
    }
}
