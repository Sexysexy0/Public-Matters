// InstitutionalSentimentDAO.sol
pragma solidity ^0.8.0;

contract InstitutionalSentimentDAO {
    struct Survey {
        uint256 id;
        string entity;   // e.g. "ETF Manager", "Hedge Fund"
        string outlook;  // e.g. "Bullish", "Bearish"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public surveyCount;
    mapping(uint256 => Survey) public surveys;

    event SurveyCreated(uint256 id, string entity, string outlook);
    event SurveyVoted(uint256 id, string entity, bool support);
    event SurveyPublished(uint256 id, string entity);
    event SentimentDeclared(string message);

    function createSurvey(string memory entity, string memory outlook) public {
        surveyCount++;
        surveys[surveyCount] = Survey(surveyCount, entity, outlook, 0, 0, false);
        emit SurveyCreated(surveyCount, entity, outlook);
    }

    function voteSurvey(uint256 id, bool support) public {
        if (support) {
            surveys[id].votesFor++;
        } else {
            surveys[id].votesAgainst++;
        }
        emit SurveyVoted(id, surveys[id].entity, support);
    }

    function publishSurvey(uint256 id) public {
        Survey storage s = surveys[id];
        require(!s.published, "Already published");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.published = true;
        emit SurveyPublished(s.id, s.entity);
    }

    function declareSentiment() public {
        emit SentimentDeclared("Institutional Sentiment DAO: safeguard arcs encoded into communal consequence.");
    }
}
