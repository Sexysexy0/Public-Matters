// MigrationEquitySafeguards.sol
pragma solidity ^0.8.0;

contract MigrationEquitySafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Diaspora Dignity"
        string measure;     // e.g. "Mandate fair treatment of migrant workers, safeguard against exploitation abroad and neglect at home"
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
