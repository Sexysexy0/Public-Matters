// EscalationSafeguards.sol
pragma solidity ^0.8.0;

contract EscalationSafeguards {
    struct Safeguard {
        uint256 id;
        string scenario;   // e.g. "Resource Scarcity Conflict"
        string rule;       // e.g. "Prevent AI from recommending WMDs"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string scenario, string rule);

    function logSafeguard(string memory scenario, string memory rule) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, scenario, rule, block.timestamp);
        emit SafeguardLogged(safeguardCount, scenario, rule);
    }
}
