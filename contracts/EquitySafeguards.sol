// EquitySafeguards.sol
pragma solidity ^0.8.0;

contract EquitySafeguards {
    struct Safeguard {
        uint256 id;
        string mechanism;  // e.g. "Community Share Allocation"
        string measure;    // e.g. "Distribute equity to government/community annually"
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
