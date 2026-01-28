pragma solidity ^0.8.20;

contract PublicPerceptionProtocol {
    address public admin;

    struct Perception {
        string group;        // e.g. users, critics, supporters
        string sentiment;    // e.g. distrust, humor, alarm
        string narrative;    // e.g. transparency vs misinformation
        uint256 timestamp;
    }

    Perception[] public perceptions;

    event PerceptionLogged(string group, string sentiment, string narrative, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPerception(string calldata group, string calldata sentiment, string calldata narrative) external onlyAdmin {
        perceptions.push(Perception(group, sentiment, narrative, block.timestamp));
        emit PerceptionLogged(group, sentiment, narrative, block.timestamp);
    }

    function totalPerceptions() external view returns (uint256) {
        return perceptions.length;
    }
}
