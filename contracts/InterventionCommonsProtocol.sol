pragma solidity ^0.8.20;

contract InterventionCommonsProtocol {
    address public admin;

    struct Intervention {
        string actor;        // e.g. US, allies, communal forces
        string purpose;      // e.g. protect civilians, dismantle regime
        uint256 timestamp;
    }

    Intervention[] public interventions;

    event InterventionLogged(string actor, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIntervention(string calldata actor, string calldata purpose) external onlyAdmin {
        interventions.push(Intervention(actor, purpose, block.timestamp));
        emit InterventionLogged(actor, purpose, block.timestamp);
    }

    function totalInterventions() external view returns (uint256) {
        return interventions.length;
    }
}
