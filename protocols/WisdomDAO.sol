// WisdomDAO.sol
pragma solidity ^0.8.0;

contract WisdomDAO {
    struct Insight {
        uint256 id;
        string source;    // e.g. "Community Forum"
        string lesson;    // e.g. "DIY Unlock Guide"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public insightCount;
    mapping(uint256 => Insight) public insights;

    event InsightCreated(uint256 id, string source, string lesson);
    event InsightVoted(uint256 id, string source, bool support);
    event InsightRatified(uint256 id, string source);
    event WisdomDeclared(string message);

    function createInsight(string memory source, string memory lesson) public {
        insightCount++;
        insights[insightCount] = Insight(insightCount, source, lesson, 0, 0, false);
        emit InsightCreated(insightCount, source, lesson);
    }

    function voteInsight(uint256 id, bool support) public {
        if (support) {
            insights[id].votesFor++;
        } else {
            insights[id].votesAgainst++;
        }
        emit InsightVoted(id, insights[id].source, support);
    }

    function ratifyInsight(uint256 id) public {
        Insight storage i = insights[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit InsightRatified(i.id, i.source);
    }

    function declareWisdom() public {
        emit WisdomDeclared("Wisdom DAO: safeguard arcs encoded into communal consequence.");
    }
}
