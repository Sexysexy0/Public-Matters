// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AgencyResonanceShield {
    struct AgencyResonance {
        address overseer;
        string arc;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    AgencyResonance[] public agencies;

    event AgencyResonanceLogged(address indexed overseer, string arc, string safeguard);
    event AgencyResonanceSafeguarded(uint256 indexed id, address verifier);

    function logAgencyResonance(string memory _arc, string memory _safeguard) public {
        agencies.push(AgencyResonance(msg.sender, _arc, _safeguard, block.timestamp, false));
        emit AgencyResonanceLogged(msg.sender, _arc, _safeguard);
    }

    function safeguardAgencyResonance(uint256 _id) public {
        require(_id < agencies.length, "Invalid ID");
        agencies[_id].safeguarded = true;
        emit AgencyResonanceSafeguarded(_id, msg.sender);
    }

    function getAgencyResonance(uint256 _id) public view returns (AgencyResonance memory) {
        require(_id < agencies.length, "Invalid ID");
        return agencies[_id];
    }

    function totalAgencies() public view returns (uint256) {
        return agencies.length;
    }
}
