// BudgetTransparencySafeguards.sol
pragma solidity ^0.8.0;

contract BudgetTransparencySafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Transparency in Fiscal Discipline"
        string measure;     // e.g. "Require prioritization of programmed appropriations, mandate disclosure of SARO listings, enforce certification of excess income"
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
