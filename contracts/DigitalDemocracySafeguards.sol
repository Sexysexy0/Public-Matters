// DigitalDemocracySafeguards.sol
pragma solidity ^0.8.0;

contract DigitalDemocracySafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Protect E-Governance Integrity"
        string measure;     // e.g. "Mandate open-source transparency and citizen access to digital governance systems"
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
