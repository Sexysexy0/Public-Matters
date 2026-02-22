// TreatyDAO.sol
pragma solidity ^0.8.0;

contract TreatyDAO {
    struct Agreement {
        uint256 id;
        string focus;     // e.g. "Arms Control Treaty"
        string proposer;  // e.g. "Diplomatic Council"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public agreementCount;
    mapping(uint256 => Agreement) public agreements;

    event AgreementCreated(uint256 id, string focus, string proposer);
    event AgreementVoted(uint256 id, string focus, bool support);
    event AgreementRatified(uint256 id, string focus);
    event TreatyDeclared(string message);

    function createAgreement(string memory focus, string memory proposer) public {
        agreementCount++;
        agreements[agreementCount] = Agreement(agreementCount, focus, proposer, 0, 0, false);
        emit AgreementCreated(agreementCount, focus, proposer);
    }

    function voteAgreement(uint256 id, bool support) public {
        if (support) {
            agreements[id].votesFor++;
        } else {
            agreements[id].votesAgainst++;
        }
        emit AgreementVoted(id, agreements[id].focus, support);
    }

    function ratifyAgreement(uint256 id) public {
        Agreement storage a = agreements[id];
        require(!a.ratified, "Already ratified");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.ratified = true;
        emit AgreementRatified(a.id, a.focus);
    }

    function declareTreaty() public {
        emit TreatyDeclared("Treaty DAO: safeguard arcs encoded into communal consequence.");
    }
}
