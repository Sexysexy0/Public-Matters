pragma solidity ^0.8.0;

contract CommunityDonationLedger {
    event EquityAlert(string recipient, string issue);

    function checkDistribution(string memory recipient, bool received) public {
        if (!received) {
            emit EquityAlert(recipient, "Recipient excluded – inclusion safeguard required");
        }
    }
}
