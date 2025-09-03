// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FlightRouteAudit {
    address public steward;
    mapping(string => bool) public flightAllowed;

    event FlightBlocked(string region);
    event FlightAllowed(string region);

    constructor() {
        steward = msg.sender;
        flightAllowed["China"] = false;
        flightAllowed["Russia"] = false;
        flightAllowed["India"] = true;
        flightAllowed["Japan"] = true;
        flightAllowed["PH"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function blockFlight(string memory region) public onlySteward {
        flightAllowed[region] = false;
        emit FlightBlocked(region);
    }

    function allowFlight(string memory region) public onlySteward {
        flightAllowed[region] = true;
        emit FlightAllowed(region);
    }

    function canFlyTo(string memory region) public view returns (bool) {
        return flightAllowed[region];
    }
}
