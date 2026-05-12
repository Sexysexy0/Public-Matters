// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LeakDefenseLedger {
    struct Incident {
        address offender;
        string description;
        bool isScalping;
        bool isPiracy;
        uint256 timestamp;
    }

    Incident[] public incidents;

    event IncidentLogged(address indexed offender, bool isScalping, bool isPiracy);

    function logIncident(address _offender, string memory _desc, bool _scalping, bool _piracy) public {
        incidents.push(Incident(_offender, _desc, _scalping, _piracy, block.timestamp));
        emit IncidentLogged(_offender, _scalping, _piracy);
    }

    function getIncident(uint256 _id) public view returns (Incident memory) {
        require(_id < incidents.length, "Invalid ID");
        return incidents[_id];
    }

    function totalIncidents() public view returns (uint256) {
        return incidents.length;
    }
}
