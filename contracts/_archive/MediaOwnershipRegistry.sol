pragma solidity ^0.8.0;

contract MediaOwnershipRegistry {
    event OwnershipDisclosure(string channel, string newOwner);

    function disclose(string memory channel, string memory newOwner) public {
        emit OwnershipDisclosure(channel, newOwner);
    }
}
