// ColonialLegacySafeguards.sol
pragma solidity ^0.8.0;

contract ColonialLegacySafeguards {
    struct Safeguard {
        uint256 id;
        string injustice;   // e.g. "Land dispossession during Spanish era"
        string repair;      // e.g. "Restitution or reform policy"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string injustice, string repair);

    function logSafeguard(string memory injustice, string memory repair) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, injustice, repair, block.timestamp);
        emit SafeguardLogged(safeguardCount, injustice, repair);
    }
}
