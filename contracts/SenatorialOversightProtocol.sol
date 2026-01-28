pragma solidity ^0.8.20;

contract SenatorialOversightProtocol {
    address public admin;

    struct Oversight {
        string senator;      // e.g. Raffy Tulfo
        string target;       // e.g. Bureau of Immigration
        string demand;       // e.g. stop arbitrary offloading
        uint256 timestamp;
    }

    Oversight[] public oversights;

    event OversightLogged(string senator, string target, string demand, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOversight(string calldata senator, string calldata target, string calldata demand) external onlyAdmin {
        oversights.push(Oversight(senator, target, demand, block.timestamp));
        emit OversightLogged(senator, target, demand, block.timestamp);
    }

    function totalOversights() external view returns (uint256) {
        return oversights.length;
    }
}
