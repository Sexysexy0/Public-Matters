pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DriverUnionDonationProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event DonationActivation(string union, string item, uint256 quantity);

    function distributeAid(string memory union, string memory item, uint256 quantity, bool verifiedMember) public {
        if (verifiedMember) {
            emit DonationActivation(union, item, quantity);
        }
    }
}
