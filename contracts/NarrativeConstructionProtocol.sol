pragma solidity ^0.8.20;

contract NarrativeConstructionProtocol {
    address public admin;

    struct Narrative {
        string event;        // e.g. fee, delay, ambiguous signal
        string interpretation; // e.g. crime, collapse, conspiracy
        uint256 timestamp;
    }

    Narrative[] public narratives;

    event NarrativeLogged(string event, string interpretation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logNarrative(string calldata event, string calldata interpretation) external onlyAdmin {
        narratives.push(Narrative(event, interpretation, block.timestamp));
        emit NarrativeLogged(event, interpretation, block.timestamp);
    }

    function totalNarratives() external view returns (uint256) {
        return narratives.length;
    }
}
