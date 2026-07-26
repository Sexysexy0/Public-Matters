// MilkEquitySafeguards.sol
pragma solidity ^0.8.0;

contract MilkEquitySafeguards {
    struct Safeguard {
        uint256 id;
        string principle;   // e.g. "Dairy Resilience"
        string measure;     // e.g. "Mandate support for carabao milk, prohibit exploitative imports, protect dignity in farmer livelihood"
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
