// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityResonanceBridge {
    struct EquityResonance {
        address participant;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    EquityResonance[] public resonances;

    event EquityResonanceLogged(address indexed participant, string context, string safeguard);
    event EquityResonanceSafeguarded(uint256 indexed id, address verifier);

    function logEquityResonance(string memory _context, string memory _safeguard) public {
        resonances.push(EquityResonance(msg.sender, _context, _safeguard, block.timestamp, false));
        emit EquityResonanceLogged(msg.sender, _context, _safeguard);
    }

    function safeguardEquityResonance(uint256 _id) public {
        require(_id < resonances.length, "Invalid ID");
        resonances[_id].safeguarded = true;
        emit EquityResonanceSafeguarded(_id, msg.sender);
    }

    function getEquityResonance(uint256 _id) public view returns (EquityResonance memory) {
        require(_id < resonances.length, "Invalid ID");
        return resonances[_id];
    }

    function totalEquityResonances() public view returns (uint256) {
        return resonances.length;
    }
}
