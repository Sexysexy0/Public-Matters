// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LocalInventorGrant is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Inventor {
        string name;
        string inventionType; // e.g., "Plastic-to-Fuel", "Water-Hydrogen"
        uint256 grantAmount;
        bool isVerifiedByDOST;
    }

    mapping(address => Inventor) public inventors;

    // Direct funding para sa mga prototype development
    function applyForGrant(string memory _name, string memory _type) public {
        inventors[msg.sender] = Inventor(_name, _type, 0, false);
    }

    function releaseFunds(address _inventor) public payable {
        // Funds are released based on milestones, hindi sa "kakilala" system
        (bool success, ) = payable(_inventor).call{value: msg.value}(""); require(success, "Transfer failed");
    }
}
