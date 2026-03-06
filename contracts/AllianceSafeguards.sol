// AllianceSafeguards.sol
pragma solidity ^0.8.0;

contract AllianceSafeguards {
    struct Safeguard {
        uint256 id;
        string partner;    // e.g. "Defense Treaty Partner"
        string measure;    // e.g. "Evaluate reliability of defense agreements"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string partner, string measure);

    function logSafeguard(string memory partner, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, partner, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, partner, measure);
    }
}
