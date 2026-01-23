pragma solidity ^0.8.20;

contract GlobalPerceptionProtocol {
    address public admin;

    struct Perception {
        string agency;       // e.g. Mossad, CIA
        string action;       // e.g. high-risk operation, covert mission
        string perception;   // e.g. reckless, reliable, weakened
        uint256 timestamp;
    }

    Perception[] public perceptions;

    event PerceptionLogged(string agency, string action, string perception, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPerception(string calldata agency, string calldata action, string calldata perception) external onlyAdmin {
        perceptions.push(Perception(agency, action, perception, block.timestamp));
        emit PerceptionLogged(agency, action, perception, block.timestamp);
    }

    function totalPerceptions() external view returns (uint256) {
        return perceptions.length;
    }
}
