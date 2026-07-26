// EternalOwnershipRegistry.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EternalOwnershipRegistry is Ownable {

    constructor() Ownable(msg.sender) {}

    struct DigitalGood {
        string title;
        bool isFunctioning;
        address publisher;
    }

    mapping(bytes32 => address) public licenseOwner;

    function verifyAccess(bytes32 _licenseId) public view returns (bool) {
        // Proof of ownership that exists outside of the publisher's database
        return licenseOwner[_licenseId] == msg.sender;
    }
}
