pragma solidity ^0.8.20;

contract HighEffortIntelligenceProtocol {
    address public admin;

    struct Teaching {
        string scenario;     // e.g. Taxes to Caesar, Healing on Sabbath
        string solution;     // e.g. clever reframing, moral dilemma
        string effect;       // e.g. audience reflection, Pharisee silence
        uint256 timestamp;
    }

    Teaching[] public teachings;

    event TeachingLogged(string scenario, string solution, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTeaching(string calldata scenario, string calldata solution, string calldata effect) external onlyAdmin {
        teachings.push(Teaching(scenario, solution, effect, block.timestamp));
        emit TeachingLogged(scenario, solution, effect, block.timestamp);
    }

    function totalTeachings() external view returns (uint256) {
        return teachings.length;
    }
}
