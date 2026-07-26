// ResonanceFixProtocol.sol
pragma solidity ^0.8.0;

contract ResonanceFixProtocol {
    struct Insight {
        uint256 id;
        string domain;    // e.g. "API Calls"
        string fix;       // e.g. "Retry logic added"
        string outcome;   // e.g. "Stable"
        uint256 timestamp;
    }

    uint256 public insightCount;
    mapping(uint256 => Insight) public insights;

    event InsightLogged(uint256 id, string domain, string fix, string outcome);

    function logInsight(string memory domain, string memory fix, string memory outcome) public {
        insightCount++;
        insights[insightCount] = Insight(insightCount, domain, fix, outcome, block.timestamp);
        emit InsightLogged(insightCount, domain, fix, outcome);
    }
}
