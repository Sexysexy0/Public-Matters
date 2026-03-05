// StabilityResonanceProtocol.sol
pragma solidity ^0.8.0;

contract StabilityResonanceProtocol {
    struct Safeguard {
        uint256 id;
        string domain;    // e.g. "Community Security"
        string measure;   // e.g. "Open internet access"
        string outcome;   // e.g. "Trust preserved"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string domain, string measure, string outcome);

    function logSafeguard(string memory domain, string memory measure, string memory outcome) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, domain, measure, outcome, block.timestamp);
        emit SafeguardLogged(safeguardCount, domain, measure, outcome);
    }
}
