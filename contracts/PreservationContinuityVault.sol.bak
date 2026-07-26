// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PreservationContinuityVault {
    struct Legacy {
        address curator;
        string title;
        string platform;
        uint256 timestamp;
        bool safeguarded;
    }

    Legacy[] public legacies;

    event LegacyLogged(address indexed curator, string title, string platform);
    event LegacySafeguarded(uint256 indexed id, address verifier);

    function logLegacy(string memory _title, string memory _platform) public {
        legacies.push(Legacy(msg.sender, _title, _platform, block.timestamp, false));
        emit LegacyLogged(msg.sender, _title, _platform);
    }

    function safeguardLegacy(uint256 _id) public {
        require(_id < legacies.length, "Invalid ID");
        legacies[_id].safeguarded = true;
        emit LegacySafeguarded(_id, msg.sender);
    }

    function getLegacy(uint256 _id) public view returns (Legacy memory) {
        require(_id < legacies.length, "Invalid ID");
        return legacies[_id];
    }

    function totalLegacies() public view returns (uint256) {
        return legacies.length;
    }
}
