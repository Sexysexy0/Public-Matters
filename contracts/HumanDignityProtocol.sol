pragma solidity ^0.8.20;

contract HumanDignityProtocol {
    address public admin;

    struct Dignity {
        string challenge;    // e.g. AI displacement, poverty, adversity
        string preservation; // e.g. resilience, identity, service
        uint256 timestamp;
    }

    Dignity[] public dignities;

    event DignityLogged(string challenge, string preservation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDignity(string calldata challenge, string calldata preservation) external onlyAdmin {
        dignities.push(Dignity(challenge, preservation, block.timestamp));
        emit DignityLogged(challenge, preservation, block.timestamp);
    }

    function totalDignities() external view returns (uint256) {
        return dignities.length;
    }
}
