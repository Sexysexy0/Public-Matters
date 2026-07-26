pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CommunityEquityLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EquityAlert(string recipient, string issue);

    function checkDistribution(string memory recipient, bool received) public {
        if (!received) {
            emit EquityAlert(recipient, "Recipient excluded – inclusion safeguard required");
        }
    }
}
