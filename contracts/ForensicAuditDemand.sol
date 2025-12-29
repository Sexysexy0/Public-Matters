// contracts/ForensicAuditDemand.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ForensicAuditDemand
 * @notice Logs demands for forensic audits of public funds.
 */
contract ForensicAuditDemand {
    address public admin;

    struct Demand {
        string requester;   // "Resident", "CommunityGroup"
        string scope;       // "CityFunds", "CountyFunds"
        uint256 timestamp;
    }

    Demand[] public demands;

    event DemandLogged(string requester, string scope, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDemand(string calldata requester, string calldata scope) external onlyAdmin {
        demands.push(Demand(requester, scope, block.timestamp));
        emit DemandLogged(requester, scope, block.timestamp);
    }

    function totalDemands() external view returns (uint256) { return demands.length; }

    function getDemand(uint256 id) external view returns (Demand memory) {
        require(id < demands.length, "Invalid id");
        return demands[id];
    }
}
