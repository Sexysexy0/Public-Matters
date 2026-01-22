pragma solidity ^0.8.20;

contract GlobalizationFailureProtocol {
    address public admin;

    struct Critique {
        string actor;        // e.g. Trump, Lutnik
        string claim;        // e.g. globalization failed the West
        string implication;  // e.g. need for nationalist correction
        uint256 timestamp;
    }

    Critique[] public critiques;

    event CritiqueLogged(string actor, string claim, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCritique(string calldata actor, string calldata claim, string calldata implication) external onlyAdmin {
        critiques.push(Critique(actor, claim, implication, block.timestamp));
        emit CritiqueLogged(actor, claim, implication, block.timestamp);
    }

    function totalCritiques() external view returns (uint256) {
        return critiques.length;
    }
}
