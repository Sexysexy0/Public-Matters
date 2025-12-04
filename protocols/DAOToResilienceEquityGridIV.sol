// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToResilienceEquityGridIV {
    string public batchID = "1321.9.256";
    string public steward = "Vinvin";

    address public admin;

    struct Resilience {
        string hazard;     // flood, typhoon, drought, wildfire
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Resilience[] public hazards;

    event ResilienceLogged(string hazard, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logResilience(string memory hazard, string memory status) public onlyAdmin {
        hazards.push(Resilience(hazard, status, block.timestamp));
        emit ResilienceLogged(hazard, status);
    }

    function getResilience(uint256 index) public view returns (string memory hazard, string memory status, uint256 timestamp) {
        Resilience memory r = hazards[index];
        return (r.hazard, r.status, r.timestamp);
    }
}
