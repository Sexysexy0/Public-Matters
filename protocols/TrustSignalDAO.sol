// TrustSignalDAO.sol
pragma solidity ^0.8.0;

contract TrustSignalDAO {
    struct Signal {
        uint256 id;
        string source;   // e.g. "ETF Inflows", "Institutional Statements"
        string status;   // e.g. "Positive", "Negative"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public signalCount;
    mapping(uint256 => Signal) public signals;

    event SignalCreated(uint256 id, string source, string status);
    event SignalVoted(uint256 id, string source, bool support);
    event SignalPublished(uint256 id, string source);
    event TrustDeclared(string message);

    function createSignal(string memory source, string memory status) public {
        signalCount++;
        signals[signalCount] = Signal(signalCount, source, status, 0, 0, false);
        emit SignalCreated(signalCount, source, status);
    }

    function voteSignal(uint256 id, bool support) public {
        if (support) {
            signals[id].votesFor++;
        } else {
            signals[id].votesAgainst++;
        }
        emit SignalVoted(id, signals[id].source, support);
    }

    function publishSignal(uint256 id) public {
        Signal storage s = signals[id];
        require(!s.published, "Already published");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.published = true;
        emit SignalPublished(s.id, s.source);
    }

    function declareTrust() public {
        emit TrustDeclared("Trust Signal DAO: safeguard arcs encoded into communal consequence.");
    }
}
