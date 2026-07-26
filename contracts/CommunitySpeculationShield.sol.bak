// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunitySpeculationShield {
    struct Speculation {
        address participant;
        string theory;
        uint256 timestamp;
        bool safeguarded;
    }

    Speculation[] public speculations;

    event SpeculationLogged(address indexed participant, string theory);
    event SpeculationSafeguarded(uint256 indexed id, address verifier);

    function logSpeculation(string memory _theory) public {
        speculations.push(Speculation(msg.sender, _theory, block.timestamp, false));
        emit SpeculationLogged(msg.sender, _theory);
    }

    function safeguardSpeculation(uint256 _id) public {
        require(_id < speculations.length, "Invalid ID");
        speculations[_id].safeguarded = true;
        emit SpeculationSafeguarded(_id, msg.sender);
    }

    function getSpeculation(uint256 _id) public view returns (Speculation memory) {
        require(_id < speculations.length, "Invalid ID");
        return speculations[_id];
    }

    function totalSpeculations() public view returns (uint256) {
        return speculations.length;
    }
}
