// NoTaxSafeguards.sol
pragma solidity ^0.8.0;

contract NoTaxSafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "No Tax on Oil and Basic Needs"
        string measure;     // e.g. "Remove VAT and excise tax on fuel, food, water, electricity; protect dignity in citizen access"
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
