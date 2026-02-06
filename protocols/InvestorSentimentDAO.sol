// InvestorSentimentDAO.sol
pragma solidity ^0.8.0;

contract InvestorSentimentDAO {
    struct Survey {
        uint256 id;
        string group;   // e.g. "Retail Traders", "Institutions"
        string sentiment; // e.g. "Bullish", "Bearish"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public surveyCount;
    mapping(uint256 => Survey) public surveys;

    event SurveyCreated(uint256 id, string group, string sentiment);
    event SurveyVoted(uint256 id, string group, bool support);
    event SurveyPublished(uint256 id, string group);
    event SentimentDeclared(string message);

    function createSurvey(string memory group, string memory sentiment) public {
        surveyCount++;
        surveys[surveyCount] = Survey(surveyCount, group, sentiment, 0, 0, false);
        emit SurveyCreated(surveyCount, group, sentiment);
    }

    function voteSurvey(uint256 id, bool support) public {
        if (support) {
            surveys[id].votesFor++;
        } else {
            surveys[id].votesAgainst++;
        }
        emit SurveyVoted(id, surveys[id].group, support);
    }

    function publishSurvey(uint256 id) public {
        Survey storage s = surveys[id];
        require(!s.published, "Already published");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.published = true;
        emit SurveyPublished(s.id, s.group);
    }

    function declareSentiment() public {
        emit SentimentDeclared("Investor Sentiment DAO: safeguard arcs encoded into communal consequence.");
    }
}
