pragma solidity ^0.8.20;

contract ManufacturingResilienceProtocol {
    address public admin;

    struct Resilience {
        string sector;       // e.g. vaccines, petrochemicals, nickel
        string strength;     // e.g. domestic capacity, currency independence, multiplier effect
        uint256 timestamp;
    }

    Resilience[] public resiliences;

    event ResilienceLogged(string sector, string strength, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata sector, string calldata strength) external onlyAdmin {
        resiliences.push(Resilience(sector, strength, block.timestamp));
        emit ResilienceLogged(sector, strength, block.timestamp);
    }

    function totalResiliences() external view returns (uint256) {
        return resiliences.length;
    }
}
