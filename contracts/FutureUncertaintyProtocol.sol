pragma solidity ^0.8.20;

contract FutureUncertaintyProtocol {
    address public admin;

    struct Uncertainty {
        string actor;        // e.g. allies, middle powers
        string dilemma;      // e.g. pragmatism vs ideals
        string trajectory;   // e.g. appeasement, stability, alliance fracture
        uint256 timestamp;
    }

    Uncertainty[] public uncertainties;

    event UncertaintyLogged(string actor, string dilemma, string trajectory, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUncertainty(string calldata actor, string calldata dilemma, string calldata trajectory) external onlyAdmin {
        uncertainties.push(Uncertainty(actor, dilemma, trajectory, block.timestamp));
        emit UncertaintyLogged(actor, dilemma, trajectory, block.timestamp);
    }

    function totalUncertainties() external view returns (uint256) {
        return uncertainties.length;
    }
}
