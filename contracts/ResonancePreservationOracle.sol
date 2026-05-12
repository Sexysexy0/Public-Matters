// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResonancePreservationOracle {
    struct Preservation {
        address curator;
        string title;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Preservation[] public preservations;

    event PreservationLogged(address indexed curator, string title, string safeguard);
    event PreservationSafeguarded(uint256 indexed id, address verifier);

    function logPreservation(string memory _title, string memory _safeguard) public {
        preservations.push(Preservation(msg.sender, _title, _safeguard, block.timestamp, false));
        emit PreservationLogged(msg.sender, _title, _safeguard);
    }

    function safeguardPreservation(uint256 _id) public {
        require(_id < preservations.length, "Invalid ID");
        preservations[_id].safeguarded = true;
        emit PreservationSafeguarded(_id, msg.sender);
    }

    function getPreservation(uint256 _id) public view returns (Preservation memory) {
        require(_id < preservations.length, "Invalid ID");
        return preservations[_id];
    }

    function totalPreservations() public view returns (uint256) {
        return preservations.length;
    }
}
