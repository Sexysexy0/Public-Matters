// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlayerAgencyShield {
    struct Agency {
        address player;
        string choice;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    Agency[] public agencies;

    event AgencyLogged(address indexed player, string choice, string safeguard);
    event AgencySafeguarded(uint256 indexed id, address verifier);

    function logAgency(string memory _choice, string memory _safeguard) public {
        agencies.push(Agency(msg.sender, _choice, _safeguard, block.timestamp, false));
        emit AgencyLogged(msg.sender, _choice, _safeguard);
    }

    function safeguardAgency(uint256 _id) public {
        require(_id < agencies.length, "Invalid ID");
        agencies[_id].safeguarded = true;
        emit AgencySafeguarded(_id, msg.sender);
    }

    function getAgency(uint256 _id) public view returns (Agency memory) {
        require(_id < agencies.length, "Invalid ID");
        return agencies[_id];
    }

    function totalAgencies() public view returns (uint256) {
        return agencies.length;
    }
}
