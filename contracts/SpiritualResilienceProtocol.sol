pragma solidity ^0.8.20;

contract SpiritualResilienceProtocol {
    address public admin;

    struct Resilience {
        string practice;     // e.g. prayer, faith, community support
        string outcome;      // e.g. strengthened believers, resistance to deception
        uint256 timestamp;
    }

    Resilience[] public resiliences;

    event ResilienceLogged(string practice, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata practice, string calldata outcome) external onlyAdmin {
        resiliences.push(Resilience(practice, outcome, block.timestamp));
        emit ResilienceLogged(practice, outcome, block.timestamp);
    }

    function totalResiliences() external view returns (uint256) {
        return resiliences.length;
    }
}
