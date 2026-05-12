// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NitroContinuityBridge {
    struct Benefit {
        address subscriber;
        string service;
        string perk;
        uint256 timestamp;
        bool safeguarded;
    }

    Benefit[] public benefits;

    event BenefitLogged(address indexed subscriber, string service, string perk);
    event BenefitSafeguarded(uint256 indexed id, address verifier);

    function logBenefit(string memory _service, string memory _perk) public {
        benefits.push(Benefit(msg.sender, _service, _perk, block.timestamp, false));
        emit BenefitLogged(msg.sender, _service, _perk);
    }

    function safeguardBenefit(uint256 _id) public {
        require(_id < benefits.length, "Invalid ID");
        benefits[_id].safeguarded = true;
        emit BenefitSafeguarded(_id, msg.sender);
    }

    function getBenefit(uint256 _id) public view returns (Benefit memory) {
        require(_id < benefits.length, "Invalid ID");
        return benefits[_id];
    }

    function totalBenefits() public view returns (uint256) {
        return benefits.length;
    }
}
