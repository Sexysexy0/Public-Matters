pragma solidity ^0.8.20;

contract CryptoResilienceProtocol {
    address public admin;

    struct Resilience {
        string challenge;    // e.g. quantum threat, regulation, volatility
        string response;     // e.g. upgrade, fork, adoption
        uint256 timestamp;
    }

    Resilience[] public resiliences;

    event ResilienceLogged(string challenge, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResilience(string calldata challenge, string calldata response) external onlyAdmin {
        resiliences.push(Resilience(challenge, response, block.timestamp));
        emit ResilienceLogged(challenge, response, block.timestamp);
    }

    function totalResiliences() external view returns (uint256) {
        return resiliences.length;
    }
}
