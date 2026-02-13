// ConsentDAO.sol
pragma solidity ^0.8.0;

contract ConsentDAO {
    struct Consent {
        uint256 id;
        string subject;   // e.g. "Digital Clone", "Posthumous Posting"
        string status;    // e.g. "Granted", "Revoked"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public consentCount;
    mapping(uint256 => Consent) public consents;

    event ConsentCreated(uint256 id, string subject, string status);
    event ConsentVoted(uint256 id, string subject, bool support);
    event ConsentResolved(uint256 id, string subject);
    event ConsentDeclared(string message);

    function createConsent(string memory subject, string memory status) public {
        consentCount++;
        consents[consentCount] = Consent(consentCount, subject, status, 0, 0, false);
        emit ConsentCreated(consentCount, subject, status);
    }

    function voteConsent(uint256 id, bool support) public {
        if (support) {
            consents[id].votesFor++;
        } else {
            consents[id].votesAgainst++;
        }
        emit ConsentVoted(id, consents[id].subject, support);
    }

    function resolveConsent(uint256 id) public {
        Consent storage c = consents[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit ConsentResolved(c.id, c.subject);
    }

    function declareConsent() public {
        emit ConsentDeclared("Consent DAO: safeguard arcs encoded into communal consequence.");
    }
}
