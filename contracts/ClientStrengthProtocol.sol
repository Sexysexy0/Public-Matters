pragma solidity ^0.8.20;

contract ClientStrengthProtocol {
    address public admin;

    struct Strength {
        string client;       // e.g. consumer, institution, community
        string support;      // e.g. credit, capital, advisory
        uint256 timestamp;
    }

    Strength[] public strengths;

    event StrengthLogged(string client, string support, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStrength(string calldata client, string calldata support) external onlyAdmin {
        strengths.push(Strength(client, support, block.timestamp));
        emit StrengthLogged(client, support, block.timestamp);
    }

    function totalStrengths() external view returns (uint256) {
        return strengths.length;
    }
}
