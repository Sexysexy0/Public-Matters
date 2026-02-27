// ResearchDAO.sol
pragma solidity ^0.8.0;

contract ResearchDAO {
    struct Study {
        uint256 id;
        string institution; // e.g. "MIT"
        string focus;       // e.g. "Behavioral Internet Actions"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public studyCount;
    mapping(uint256 => Study) public studies;

    event StudyCreated(uint256 id, string institution, string focus);
    event StudyVoted(uint256 id, string institution, bool support);
    event StudyRatified(uint256 id, string institution);
    event ResearchDeclared(string message);

    function createStudy(string memory institution, string memory focus) public {
        studyCount++;
        studies[studyCount] = Study(studyCount, institution, focus, 0, 0, false);
        emit StudyCreated(studyCount, institution, focus);
    }

    function voteStudy(uint256 id, bool support) public {
        if (support) {
            studies[id].votesFor++;
        } else {
            studies[id].votesAgainst++;
        }
        emit StudyVoted(id, studies[id].institution, support);
    }

    function ratifyStudy(uint256 id) public {
        Study storage s = studies[id];
        require(!s.ratified, "Already ratified");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.ratified = true;
        emit StudyRatified(s.id, s.institution);
    }

    function declareResearch() public {
        emit ResearchDeclared("Research DAO: safeguard arcs encoded into communal consequence.");
    }
}
