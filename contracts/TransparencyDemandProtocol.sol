pragma solidity ^0.8.20;

contract TransparencyDemandProtocol {
    address public admin;

    struct Demand {
        string document;     // e.g. NEP proponents, UA records
        string purpose;      // e.g. public access, investigation
        string status;       // e.g. requested, pending, denied
        uint256 timestamp;
    }

    Demand[] public demands;

    event DemandLogged(string document, string purpose, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDemand(string calldata document, string calldata purpose, string calldata status) external onlyAdmin {
        demands.push(Demand(document, purpose, status, block.timestamp));
        emit DemandLogged(document, purpose, status, block.timestamp);
    }

    function totalDemands() external view returns (uint256) {
        return demands.length;
    }
}
