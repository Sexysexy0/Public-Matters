pragma solidity ^0.8.20;

contract DefaultScenarioProtocol {
    address public admin;

    struct Default {
        string typeOf;       // e.g. gradual, sudden
        string consequence;  // e.g. layoffs, social program cuts
        string severity;     // e.g. hyperinflation, systemic shock
        uint256 timestamp;
    }

    Default[] public defaults;

    event DefaultLogged(string typeOf, string consequence, string severity, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDefault(string calldata typeOf, string calldata consequence, string calldata severity) external onlyAdmin {
        defaults.push(Default(typeOf, consequence, severity, block.timestamp));
        emit DefaultLogged(typeOf, consequence, severity, block.timestamp);
    }

    function totalDefaults() external view returns (uint256) {
        return defaults.length;
    }
}
