pragma solidity ^0.8.20;

contract InflationProtocol {
    address public admin;

    struct Inflation {
        string driver;       // e.g. money printing, deficit spending
        string effect;       // e.g. hyperinflation, loss of purchasing power
        string scale;        // e.g. gradual or sudden
        uint256 timestamp;
    }

    Inflation[] public inflations;

    event InflationLogged(string driver, string effect, string scale, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInflation(string calldata driver, string calldata effect, string calldata scale) external onlyAdmin {
        inflations.push(Inflation(driver, effect, scale, block.timestamp));
        emit InflationLogged(driver, effect, scale, block.timestamp);
    }

    function totalInflations() external view returns (uint256) {
        return inflations.length;
    }
}
