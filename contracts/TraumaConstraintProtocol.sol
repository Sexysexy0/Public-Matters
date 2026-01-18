pragma solidity ^0.8.20;

contract TraumaConstraintProtocol {
    address public admin;

    struct Constraint {
        string origin;       // e.g. Marcos era industrial policy failure
        string limitation;   // e.g. consensus against expansive monetary policy
        uint256 timestamp;
    }

    Constraint[] public constraints;

    event ConstraintLogged(string origin, string limitation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConstraint(string calldata origin, string calldata limitation) external onlyAdmin {
        constraints.push(Constraint(origin, limitation, block.timestamp));
        emit ConstraintLogged(origin, limitation, block.timestamp);
    }

    function totalConstraints() external view returns (uint256) {
        return constraints.length;
    }
}
