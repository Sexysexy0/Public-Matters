// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToLogisticsEquityGrid {
    string public batchID = "1321.9.244";
    string public steward = "Vinvin";

    address public admin;

    struct Logistics {
        string route;       // domestic, international, regional
        string status;      // equitable, pending, ghost
        uint256 timestamp;
    }

    Logistics[] public routes;

    event LogisticsLogged(string route, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logRoute(string memory route, string memory status) public onlyAdmin {
        routes.push(Logistics(route, status, block.timestamp));
        emit LogisticsLogged(route, status);
    }

    function getRoute(uint256 index) public view returns (string memory route, string memory status, uint256 timestamp) {
        Logistics memory l = routes[index];
        return (l.route, l.status, l.timestamp);
    }
}
