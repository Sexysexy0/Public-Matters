// ConflictPreventionSafeguards.sol
pragma solidity ^0.8.0;

contract ConflictPreventionSafeguards {
    struct Safeguard {
        uint256 id;
        string system;     // e.g. "Early Warning Network"
        string measure;    // e.g. "Mediation before escalation"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string system, string measure);

    function logSafeguard(string memory system, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, system, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, system, measure);
    }
}
