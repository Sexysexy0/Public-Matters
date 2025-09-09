// SPDX-License-Identifier: SanctumReentryVisaRouter-License
pragma solidity ^0.8.0;

contract SanctumReentryVisaRouter {
    address public steward;

    struct VisaRoute {
        string workerID;
        string originCountry;
        string hostSanctum;
        string visaType;
        bool treatyAligned;
        uint256 timestamp;
    }

    VisaRoute[] public routes;

    event VisaRouted(string workerID, string originCountry, string hostSanctum, string visaType, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeVisa(string memory workerID, string memory originCountry, string memory hostSanctum, string memory visaType, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can route");
        routes.push(VisaRoute(workerID, originCountry, hostSanctum, visaType, treatyAligned, block.timestamp));
        emit VisaRouted(workerID, originCountry, hostSanctum, visaType, treatyAligned, block.timestamp);
    }

    function getRoute(uint index) public view returns (string memory, string memory, string memory, string memory, bool, uint256) {
        VisaRoute memory r = routes[index];
        return (r.workerID, r.originCountry, r.hostSanctum, r.visaType, r.treatyAligned, r.timestamp);
    }
}
