// SecurityProtocol.sol
pragma solidity ^0.8.0;

contract SecurityProtocol {
    struct Threat {
        uint256 id;
        string vector;       // e.g. "iOS Exploit"
        string description;  // e.g. "Government-grade hacking tool"
        bool mitigated;
        uint256 timestamp;
    }

    uint256 public threatCount;
    mapping(uint256 => Threat) public threats;

    event ThreatMitigated(uint256 id, string vector, string description);

    function mitigateThreat(string memory vector, string memory description) public {
        threatCount++;
        threats[threatCount] = Threat(threatCount, vector, description, true, block.timestamp);
        emit ThreatMitigated(threatCount, vector, description);
    }
}
