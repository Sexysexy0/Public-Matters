// WisdomResonanceProtocol.sol
pragma solidity ^0.8.0;

contract WisdomResonanceProtocol {
    struct Insight {
        uint256 id;
        string domain;    // e.g. "Community Leadership"
        string lesson;    // e.g. "Inclusive decision-making"
        string outcome;   // e.g. "Stronger unity"
        uint256 timestamp;
    }

    uint256 public insightCount;
    mapping(uint256 => Insight) public insights;

    event InsightLogged(uint256 id, string domain, string lesson, string outcome);

    function logInsight(string memory domain, string memory lesson, string memory outcome) public {
        insightCount++;
        insights[insightCount] = Insight(insightCount, domain, lesson, outcome, block.timestamp);
        emit InsightLogged(insightCount, domain, lesson, outcome);
    }
}
