// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToShelterEquityGrid {
    string public batchID = "1321.9.253";
    string public steward = "Vinvin";

    address public admin;

    struct Shelter {
        string type;       // social housing, eco-homes, communal shelters
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Shelter[] public shelters;

    event ShelterLogged(string type, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logShelter(string memory type, string memory status) public onlyAdmin {
        shelters.push(Shelter(type, status, block.timestamp));
        emit ShelterLogged(type, status);
    }

    function getShelter(uint256 index) public view returns (string memory type, string memory status, uint256 timestamp) {
        Shelter memory s = shelters[index];
        return (s.type, s.status, s.timestamp);
    }
}
