pragma solidity ^0.8.20;

contract EuropeanDistanceProtocol {
    address public admin;

    struct Distance {
        string factor;       // e.g. weaponized dollar, military posture
        string response;     // e.g. EU drift, reduced proximity
        string implication;  // e.g. weakening alliances
        uint256 timestamp;
    }

    Distance[] public distances;

    event DistanceLogged(string factor, string response, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDistance(string calldata factor, string calldata response, string calldata implication) external onlyAdmin {
        distances.push(Distance(factor, response, implication, block.timestamp));
        emit DistanceLogged(factor, response, implication, block.timestamp);
    }

    function totalDistances() external view returns (uint256) {
        return distances.length;
    }
}
