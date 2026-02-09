// ResilienceDAO.sol
pragma solidity ^0.8.0;

contract ResilienceDAO {
    struct Test {
        uint256 id;
        string challenge;   // e.g. "Epstein Files", "Regulatory Pressure"
        string outcome;     // e.g. "Survived", "Strengthened"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public testCount;
    mapping(uint256 => Test) public tests;

    event TestCreated(uint256 id, string challenge, string outcome);
    event TestVoted(uint256 id, string challenge, bool support);
    event TestPublished(uint256 id, string challenge);
    event ResilienceDeclared(string message);

    function createTest(string memory challenge, string memory outcome) public {
        testCount++;
        tests[testCount] = Test(testCount, challenge, outcome, 0, 0, false);
        emit TestCreated(testCount, challenge, outcome);
    }

    function voteTest(uint256 id, bool support) public {
        if (support) {
            tests[id].votesFor++;
        } else {
            tests[id].votesAgainst++;
        }
        emit TestVoted(id, tests[id].challenge, support);
    }

    function publishTest(uint256 id) public {
        Test storage t = tests[id];
        require(!t.published, "Already published");
        require(t.votesFor > t.votesAgainst, "Not enough support");
        t.published = true;
        emit TestPublished(t.id, t.challenge);
    }

    function declareResilience() public {
        emit ResilienceDeclared("Resilience DAO: safeguard arcs encoded into communal consequence.");
    }
}
