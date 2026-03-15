// CitizenSafeguards.sol
pragma solidity ^0.8.0;

contract CitizenSafeguards {
    struct Safeguard {
        uint256 id;
        string mechanism;  // e.g. "Community Audit Registry"
        string measure;    // e.g. "Empower citizens to monitor governance"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string mechanism, string measure);

    function logSafeguard(string memory mechanism, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, mechanism, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, mechanism, measure);
    }
}
