pragma solidity ^0.8.0;

contract CreatorContinuityProtocol {
    event ContinuityAlert(string channel, string issue);

    function checkPresence(string memory channel, bool creatorActive) public {
        if (!creatorActive) {
            emit ContinuityAlert(channel, "Original creator removed – authenticity risk");
        }
    }
}
