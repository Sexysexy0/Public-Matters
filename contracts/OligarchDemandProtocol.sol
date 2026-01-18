,pragma solidity ^0.8.20;

contract OligarchDemandProtocol {
    address public admin;

    struct Demand {
        string oligarch;     // e.g. conglomerate, family-owned enterprise
        string requirement;  // e.g. reinvest in productive industries, support manufacturing
        uint256 timestamp;
    }

    Demand[] public demands;

    event DemandLogged(string oligarch, string requirement, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDemand(string calldata oligarch, string calldata requirement) external onlyAdmin {
        demands.push(Demand(oligarch, requirement, block.timestamp));
        emit DemandLogged(oligarch, requirement, block.timestamp);
    }

    function totalDemands() external view returns (uint256) {
        return demands.length;
    }
}
