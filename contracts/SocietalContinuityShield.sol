// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SocietalContinuityShield {
    struct Covenant {
        address participant;
        string factor;
        uint256 timestamp;
        bool safeguarded;
    }

    Covenant[] public covenants;

    event CovenantLogged(address indexed participant, string factor);
    event CovenantSafeguarded(uint256 indexed id, address verifier);

    function logCovenant(string memory _factor) public {
        covenants.push(Covenant(msg.sender, _factor, block.timestamp, false));
        emit CovenantLogged(msg.sender, _factor);
    }

    function safeguardCovenant(uint256 _id) public {
        require(_id < covenants.length, "Invalid ID");
        covenants[_id].safeguarded = true;
        emit CovenantSafeguarded(_id, msg.sender);
    }

    function getCovenant(uint256 _id) public view returns (Covenant memory) {
        require(_id < covenants.length, "Invalid ID");
        return covenants[_id];
    }

    function totalCovenants() public view returns (uint256) {
        return covenants.length;
    }
}
