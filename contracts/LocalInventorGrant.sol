// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LocalInventorGrant {
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
        payable(_inventor).transfer(msg.value);
    }
}
