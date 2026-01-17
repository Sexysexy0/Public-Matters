pragma solidity ^0.8.20;

contract OutsourcingLegacyProtocol {
    address public admin;

    struct Legacy {
        string factor;       // e.g. colonial education, English proficiency
        string outcome;      // e.g. outsourcing dominance, call center rise
        uint256 timestamp;
    }

    Legacy[] public legacies;

    event LegacyLogged(string factor, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLegacy(string calldata factor, string calldata outcome) external onlyAdmin {
        legacies.push(Legacy(factor, outcome, block.timestamp));
        emit LegacyLogged(factor, outcome, block.timestamp);
    }

    function totalLegacies() external view returns (uint256) {
        return legacies.length;
    }
}
