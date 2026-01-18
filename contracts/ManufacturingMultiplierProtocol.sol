pragma solidity ^0.8.20;

contract ManufacturingMultiplierProtocol {
    address public admin;

    struct Multiplier {
        string sector;       // e.g. vaccines, petrochemicals, nickel
        string effect;       // e.g. job creation, currency resilience, growth engine
        uint256 timestamp;
    }

    Multiplier[] public multipliers;

    event MultiplierLogged(string sector, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMultiplier(string calldata sector, string calldata effect) external onlyAdmin {
        multipliers.push(Multiplier(sector, effect, block.timestamp));
        emit MultiplierLogged(sector, effect, block.timestamp);
    }

    function totalMultipliers() external view returns (uint256) {
        return multipliers.length;
    }
}
