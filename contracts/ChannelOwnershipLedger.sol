pragma solidity ^0.8.0;

contract ChannelOwnershipLedger {
    event OwnershipChange(string channel, string newOwner);

    function discloseOwnership(string memory channel, string memory newOwner) public {
        emit OwnershipChange(channel, newOwner);
    }
}
