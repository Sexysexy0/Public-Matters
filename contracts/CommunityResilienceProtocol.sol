pragma solidity ^0.8.20;

contract CommunityResilienceProtocol {
    address public admin;

    struct Resilience {
        string city;         // e.g. Minneapolis, New York
        string action;       // e.g. observation shifts, recruitment, solidarity
        string outcome;      // e.g. sustained protests, defense networks
        uint256 timestamp;
    }

    Resilience[] public resiliences;

    event ResilienceLogged(string city, string action, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata city, string calldata action, string calldata outcome) external onlyAdmin {
        resiliences.push(Resilience(city, action, outcome, block.timestamp));
        emit ResilienceLogged(city, action, outcome, block.timestamp);
    }

    function totalResiliences() external view returns (uint256) {
        return resiliences.length;
    }
}
