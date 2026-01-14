pragma solidity ^0.8.20;

contract TransparencyArcProtocol {
    address public admin;

    struct Explanation {
        string command;      // the request
        string response;     // explanation why allowed/blocked
        uint256 timestamp;
    }

    Explanation[] public explanations;

    event ExplanationLogged(string command, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExplanation(string calldata command, string calldata response) external onlyAdmin {
        explanations.push(Explanation(command, response, block.timestamp));
        emit ExplanationLogged(command, response, block.timestamp);
    }

    function totalExplanations() external view returns (uint256) {
        return explanations.length;
    }
}
