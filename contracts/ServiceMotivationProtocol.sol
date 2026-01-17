pragma solidity ^0.8.20;

contract ServiceMotivationProtocol {
    address public admin;

    struct Motivation {
        string source;       // e.g. service, contribution, self-care
        string effect;       // e.g. fulfillment, energy, pull motivation
        uint256 timestamp;
    }

    Motivation[] public motivations;

    event MotivationLogged(string source, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMotivation(string calldata source, string calldata effect) external onlyAdmin {
        motivations.push(Motivation(source, effect, block.timestamp));
        emit MotivationLogged(source, effect, block.timestamp);
    }

    function totalMotivations() external view returns (uint256) {
        return motivations.length;
    }
}
