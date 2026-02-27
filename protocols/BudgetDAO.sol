// BudgetDAO.sol
pragma solidity ^0.8.0;

contract BudgetDAO {
    struct Plan {
        uint256 id;
        string purpose;   // e.g. "Inflation Control Fund"
        uint256 amount;
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public planCount;
    mapping(uint256 => Plan) public plans;

    event PlanCreated(uint256 id, string purpose, uint256 amount);
    event PlanVoted(uint256 id, string purpose, bool support);
    event PlanRatified(uint256 id, string purpose);
    event BudgetDeclared(string message);

    function createPlan(string memory purpose, uint256 amount) public {
        planCount++;
        plans[planCount] = Plan(planCount, purpose, amount, 0, 0, false);
        emit PlanCreated(planCount, purpose, amount);
    }

    function votePlan(uint256 id, bool support) public {
        if (support) {
            plans[id].votesFor++;
        } else {
            plans[id].votesAgainst++;
        }
        emit PlanVoted(id, plans[id].purpose, support);
    }

    function ratifyPlan(uint256 id) public {
        Plan storage p = plans[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit PlanRatified(p.id, p.purpose);
    }

    function declareBudget() public {
        emit BudgetDeclared("Budget DAO: safeguard arcs encoded into communal consequence.");
    }
}
