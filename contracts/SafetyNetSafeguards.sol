// SafetyNetSafeguards.sol
pragma solidity ^0.8.0;

contract SafetyNetSafeguards {
    struct Safeguard {
        uint256 id;
        string program;    // e.g. "Universal Healthcare"
        string measure;    // e.g. "Protect vulnerable populations"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string program, string measure);

    function logSafeguard(string memory program, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, program, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, program, measure);
    }
}
