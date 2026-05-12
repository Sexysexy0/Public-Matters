// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PartnershipEquityBridge {
    struct Partnership {
        address participant;
        string partner;
        string benefit;
        uint256 timestamp;
        bool safeguarded;
    }

    Partnership[] public partnerships;

    event PartnershipLogged(address indexed participant, string partner, string benefit);
    event PartnershipSafeguarded(uint256 indexed id, address verifier);

    function logPartnership(string memory _partner, string memory _benefit) public {
        partnerships.push(Partnership(msg.sender, _partner, _benefit, block.timestamp, false));
        emit PartnershipLogged(msg.sender, _partner, _benefit);
    }

    function safeguardPartnership(uint256 _id) public {
        require(_id < partnerships.length, "Invalid ID");
        partnerships[_id].safeguarded = true;
        emit PartnershipSafeguarded(_id, msg.sender);
    }

    function getPartnership(uint256 _id) public view returns (Partnership memory) {
        require(_id < partnerships.length, "Invalid ID");
        return partnerships[_id];
    }

    function totalPartnerships() public view returns (uint256) {
        return partnerships.length;
    }
}
