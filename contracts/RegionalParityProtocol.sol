pragma solidity ^0.8.20;

contract RegionalParityProtocol {
    address public admin;

    struct Parity {
        string region;       // e.g. NCR, Bulacan
        string adjustment;   // e.g. align wage rates
        string outcome;      // e.g. parity achieved
        uint256 timestamp;
    }

    Parity[] public parities;

    event ParityLogged(string region, string adjustment, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logParity(string calldata region, string calldata adjustment, string calldata outcome) external onlyAdmin {
        parities.push(Parity(region, adjustment, outcome, block.timestamp));
        emit ParityLogged(region, adjustment, outcome, block.timestamp);
    }

    function totalParities() external view returns (uint256) {
        return parities.length;
    }
}
