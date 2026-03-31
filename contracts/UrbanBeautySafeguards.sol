// UrbanBeautySafeguards.sol
pragma solidity ^0.8.0;

contract UrbanBeautySafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Preserve Urban Beauty in Public Spaces"
        string measure;     // e.g. "Mandate clean walls, landscaped surroundings, and aesthetic upgrades in transport corridors"
        uint256 timestamp;
    }

    uint256 public safeguardCount;
    mapping(uint256 => Safeguard) public safeguards;

    event SafeguardLogged(uint256 id, string principle, string measure);

    function logSafeguard(string memory principle, string memory measure) public {
        safeguardCount++;
        safeguards[safeguardCount] = Safeguard(safeguardCount, principle, measure, block.timestamp);
        emit SafeguardLogged(safeguardCount, principle, measure);
    }
}
