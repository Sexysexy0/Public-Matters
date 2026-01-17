pragma solidity ^0.8.20;

contract BankOppositionProtocol {
    address public admin;

    struct Opposition {
        string actor;        // e.g. large banks, community banks
        string tactic;       // e.g. lobbying, blocking rewards, red herring claims
        uint256 timestamp;
    }

    Opposition[] public oppositions;

    event OppositionLogged(string actor, string tactic, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOpposition(string calldata actor, string calldata tactic) external onlyAdmin {
        oppositions.push(Opposition(actor, tactic, block.timestamp));
        emit OppositionLogged(actor, tactic, block.timestamp);
    }

    function totalOppositions() external view returns (uint256) {
        return oppositions.length;
    }
}
