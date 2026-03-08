// RightsSafeguards.sol
pragma solidity ^0.8.0;

contract RightsSafeguards {
    struct Safeguard {
        uint256 id;
        string mechanism;  // e.g. "Anti-Discrimination Charter"
        string measure;    // e.g. "Protect individuals from discrimination and abuse"
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
