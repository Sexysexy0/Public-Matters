pragma solidity ^0.8.20;

contract CrimeLensProtocol {
    address public admin;

    struct Interpretation {
        string event;        // e.g. delay, fee, message
        string crimeLabel;   // e.g. fraud, seizure, conspiracy
        uint256 timestamp;
    }

    Interpretation[] public interpretations;

    event InterpretationLogged(string event, string crimeLabel, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInterpretation(string calldata event, string calldata crimeLabel) external onlyAdmin {
        interpretations.push(Interpretation(event, crimeLabel, block.timestamp));
        emit InterpretationLogged(event, crimeLabel, block.timestamp);
    }

    function totalInterpretations() external view returns (uint256) {
        return interpretations.length;
    }
}
