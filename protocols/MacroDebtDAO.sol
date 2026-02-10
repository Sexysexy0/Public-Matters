// MacroDebtDAO.sol
pragma solidity ^0.8.0;

contract MacroDebtDAO {
    struct Debt {
        uint256 id;
        string country;   // e.g. "United States"
        string ratio;     // e.g. "121% of GDP"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public debtCount;
    mapping(uint256 => Debt) public debts;

    event DebtCreated(uint256 id, string country, string ratio);
    event DebtVoted(uint256 id, string country, bool support);
    event DebtResolved(uint256 id, string country);
    event DebtDeclared(string message);

    function createDebt(string memory country, string memory ratio) public {
        debtCount++;
        debts[debtCount] = Debt(debtCount, country, ratio, 0, 0, false);
        emit DebtCreated(debtCount, country, ratio);
    }

    function voteDebt(uint256 id, bool support) public {
        if (support) {
            debts[id].votesFor++;
        } else {
            debts[id].votesAgainst++;
        }
        emit DebtVoted(id, debts[id].country, support);
    }

    function resolveDebt(uint256 id) public {
        Debt storage d = debts[id];
        require(!d.resolved, "Already resolved");
        require(d.votesFor > d.votesAgainst, "Not enough support");
        d.resolved = true;
        emit DebtResolved(d.id, d.country);
    }

    function declareDebt() public {
        emit DebtDeclared("Macro Debt DAO: safeguard arcs encoded into communal consequence.");
    }
}
