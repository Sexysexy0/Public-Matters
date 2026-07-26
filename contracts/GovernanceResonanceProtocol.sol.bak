// GovernanceResonanceProtocol.sol
pragma solidity ^0.8.0;

contract GovernanceResonanceProtocol {
    struct Safeguard {
        uint256 id;
        string domain;    // e.g. "Civil Security"
        string measure;   // e.g. "Protect citizens properly"
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
