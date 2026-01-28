pragma solidity ^0.8.20;

contract CommunityResilienceProtocol {
    address public admin;

    struct Resilience {
        string community;    // e.g. Dupax residents
        string strategy;     // e.g. human barricade, open letter
        string goal;         // e.g. protect land, amplify voice
        uint256 timestamp;
    }

    Resilience[] public resiliences;

    event ResilienceLogged(string community, string strategy, string goal, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata community, string calldata strategy, string calldata goal) external onlyAdmin {
        resiliences.push(Resilience(community, strategy, goal, block.timestamp));
        emit ResilienceLogged(community, strategy, goal, block.timestamp);
    }

    function totalResiliences() external view returns (uint256) {
        return resiliences.length;
    }
}
