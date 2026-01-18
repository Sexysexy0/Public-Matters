pragma solidity ^0.8.20;

contract NarrativeBeliefProtocol {
    address public admin;

    struct Belief {
        string narrative;    // e.g. crime conspiracy, collapse, law enforcement matter
        string conviction;   // e.g. absolute certainty, refusal to continue tasks
        uint256 timestamp;
    }

    Belief[] public beliefs;

    event BeliefLogged(string narrative, string conviction, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBelief(string calldata narrative, string calldata conviction) external onlyAdmin {
        beliefs.push(Belief(narrative, conviction, block.timestamp));
        emit BeliefLogged(narrative, conviction, block.timestamp);
    }

    function totalBeliefs() external view returns (uint256) {
        return beliefs.length;
    }
}
