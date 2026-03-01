// PricingDAO.sol
pragma solidity ^0.8.0;

contract PricingDAO {
    struct Plan {
        uint256 id;
        string tier;     // e.g. "Pro"
        string detail;   // e.g. "Per seat monthly, affordable"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public planCount;
    mapping(uint256 => Plan) public plans;

    event PlanCreated(uint256 id, string tier, string detail);
    event PlanVoted(uint256 id, string tier, bool support);
    event PlanRatified(uint256 id, string tier);
    event PricingDeclared(string message);

    function createPlan(string memory tier, string memory detail) public {
        planCount++;
        plans[planCount] = Plan(planCount, tier, detail, 0, 0, false);
        emit PlanCreated(planCount, tier, detail);
    }

    function votePlan(uint256 id, bool support) public {
        if (support) {
            plans[id].votesFor++;
        } else {
            plans[id].votesAgainst++;
        }
        emit PlanVoted(id, plans[id].tier, support);
    }

    function ratifyPlan(uint256 id) public {
        Plan storage p = plans[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit PlanRatified(p.id, p.tier);
    }

    function declarePricing() public {
        emit PricingDeclared("Pricing DAO: safeguard arcs encoded into communal consequence.");
    }
}
