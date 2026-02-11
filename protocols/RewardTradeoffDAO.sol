// RewardTradeoffDAO.sol
pragma solidity ^0.8.0;

contract RewardTradeoffDAO {
    struct Tradeoff {
        uint256 id;
        string reward;   // e.g. "Stablecoin Yield", "Affiliate Bonus"
        string status;   // e.g. "Allowed", "Banned"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public tradeoffCount;
    mapping(uint256 => Tradeoff) public tradeoffs;

    event TradeoffCreated(uint256 id, string reward, string status);
    event TradeoffVoted(uint256 id, string reward, bool support);
    event TradeoffResolved(uint256 id, string reward);
    event RewardDeclared(string message);

    function createTradeoff(string memory reward, string memory status) public {
        tradeoffCount++;
        tradeoffs[tradeoffCount] = Tradeoff(tradeoffCount, reward, status, 0, 0, false);
        emit TradeoffCreated(tradeoffCount, reward, status);
    }

    function voteTradeoff(uint256 id, bool support) public {
        if (support) {
            tradeoffs[id].votesFor++;
        } else {
            tradeoffs[id].votesAgainst++;
        }
        emit TradeoffVoted(id, tradeoffs[id].reward, support);
    }

    function resolveTradeoff(uint256 id) public {
        Tradeoff storage t = tradeoffs[id];
        require(!t.resolved, "Already resolved");
        require(t.votesFor > t.votesAgainst, "Not enough support");
        t.resolved = true;
        emit TradeoffResolved(t.id, t.reward);
    }

    function declareReward() public {
        emit RewardDeclared("Reward Tradeoff DAO: safeguard arcs encoded into communal consequence.");
    }
}
