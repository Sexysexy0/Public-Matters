// RecoveryDAO.sol
pragma solidity ^0.8.0;

contract RecoveryDAO {
    struct Recovery {
        uint256 id;
        string asset;   // e.g. "Bitcoin"
        string method;  // e.g. "Persuasion", "Legal Action"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public recoveryCount;
    mapping(uint256 => Recovery) public recoveries;

    event RecoveryCreated(uint256 id, string asset, string method);
    event RecoveryVoted(uint256 id, string asset, bool support);
    event RecoveryResolved(uint256 id, string asset);
    event RecoveryDeclared(string message);

    function createRecovery(string memory asset, string memory method) public {
        recoveryCount++;
        recoveries[recoveryCount] = Recovery(recoveryCount, asset, method, 0, 0, false);
        emit RecoveryCreated(recoveryCount, asset, method);
    }

    function voteRecovery(uint256 id, bool support) public {
        if (support) {
            recoveries[id].votesFor++;
        } else {
            recoveries[id].votesAgainst++;
        }
        emit RecoveryVoted(id, recoveries[id].asset, support);
    }

    function resolveRecovery(uint256 id) public {
        Recovery storage r = recoveries[id];
        require(!r.resolved, "Already resolved");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.resolved = true;
        emit RecoveryResolved(r.id, r.asset);
    }

    function declareRecovery() public {
        emit RecoveryDeclared("Recovery DAO: safeguard arcs encoded into communal consequence.");
    }
}
