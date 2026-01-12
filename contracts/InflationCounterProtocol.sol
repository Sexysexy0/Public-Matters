pragma solidity ^0.8.20;

contract InflationCounterProtocol {
    address public admin;

    struct Inflation {
        string sector;       // e.g. food, housing, energy
        uint256 rate;        // inflation percentage
        uint256 timestamp;
    }

    Inflation[] public inflations;

    event InflationLogged(string sector, uint256 rate, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInflation(string calldata sector, uint256 rate) external onlyAdmin {
        inflations.push(Inflation(sector, rate, block.timestamp));
        emit InflationLogged(sector, rate, block.timestamp);
    }

    function totalInflations() external view returns (uint256) {
        return inflations.length;
    }
}
