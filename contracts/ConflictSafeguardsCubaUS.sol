// ConflictSafeguardsCubaUS.sol
pragma solidity ^0.8.0;

contract ConflictSafeguardsCubaUS {
    struct Safeguard {
        uint256 id;
        string mechanism;  // e.g. "Sanctions Transparency Charter"
        string measure;    // e.g. "Prevent misuse of economic pressure in Cuba-US relations"
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
