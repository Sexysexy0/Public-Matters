// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacyResonanceOracle {
    struct LegacyResonance {
        address overseer;
        string arc;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    LegacyResonance[] public legacies;

    event LegacyResonanceLogged(address indexed overseer, string arc, string safeguard);
    event LegacyResonanceSafeguarded(uint256 indexed id, address verifier);

    function logLegacyResonance(string memory _arc, string memory _safeguard) public {
        legacies.push(LegacyResonance(msg.sender, _arc, _safeguard, block.timestamp, false));
        emit LegacyResonanceLogged(msg.sender, _arc, _safeguard);
    }

    function safeguardLegacyResonance(uint256 _id) public {
        require(_id < legacies.length, "Invalid ID");
        legacies[_id].safeguarded = true;
        emit LegacyResonanceSafeguarded(_id, msg.sender);
    }

    function getLegacyResonance(uint256 _id) public view returns (LegacyResonance memory) {
        require(_id < legacies.length, "Invalid ID");
        return legacies[_id];
    }

    function totalLegacies() public view returns (uint256) {
        return legacies.length;
    }
}
