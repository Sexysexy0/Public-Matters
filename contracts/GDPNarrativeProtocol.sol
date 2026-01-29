pragma solidity ^0.8.20;

contract GDPNarrativeProtocol {
    address public admin;

    struct Narrative {
        string claim;        // e.g. "Resilient economy"
        string reality;      // e.g. "Households struggling"
        uint256 timestamp;
    }

    Narrative[] public narratives;

    event NarrativeLogged(string claim, string reality, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logNarrative(string calldata claim, string calldata reality) external onlyAdmin {
        narratives.push(Narrative(claim, reality, block.timestamp));
        emit NarrativeLogged(claim, reality, block.timestamp);
    }

    function totalNarratives() external view returns (uint256) {
        return narratives.length;
    }
}
