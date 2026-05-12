// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResonanceEquityOracle {
    struct Resonance {
        address participant;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Resonance[] public resonances;

    event ResonanceLogged(address indexed participant, string context, string safeguard);
    event ResonanceSafeguarded(uint256 indexed id, address verifier);

    function logResonance(string memory _context, string memory _safeguard) public {
        resonances.push(Resonance(msg.sender, _context, _safeguard, block.timestamp, false));
        emit ResonanceLogged(msg.sender, _context, _safeguard);
    }

    function safeguardResonance(uint256 _id) public {
        require(_id < resonances.length, "Invalid ID");
        resonances[_id].safeguarded = true;
        emit ResonanceSafeguarded(_id, msg.sender);
    }

    function getResonance(uint256 _id) public view returns (Resonance memory) {
        require(_id < resonances.length, "Invalid ID");
        return resonances[_id];
    }

    function totalResonances() public view returns (uint256) {
        return resonances.length;
    }
}
