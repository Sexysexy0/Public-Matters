// CommodityFlowDAO.sol
pragma solidity ^0.8.0;

contract CommodityFlowDAO {
    struct Flow {
        uint256 id;
        string commodity;   // e.g. "Gold", "Silver", "Grain"
        string direction;   // e.g. "Inflow", "Outflow"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowCreated(uint256 id, string commodity, string direction);
    event FlowVoted(uint256 id, string commodity, bool support);
    event FlowResolved(uint256 id, string commodity);
    event CommodityDeclared(string message);

    function createFlow(string memory commodity, string memory direction) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, commodity, direction, 0, 0, false);
        emit FlowCreated(flowCount, commodity, direction);
    }

    function voteFlow(uint256 id, bool support) public {
        if (support) {
            flows[id].votesFor++;
        } else {
            flows[id].votesAgainst++;
        }
        emit FlowVoted(id, flows[id].commodity, support);
    }

    function resolveFlow(uint256 id) public {
        Flow storage f = flows[id];
        require(!f.resolved, "Already resolved");
        require(f.votesFor > f.votesAgainst, "Not enough support");
        f.resolved = true;
        emit FlowResolved(f.id, f.commodity);
    }

    function declareCommodity() public {
        emit CommodityDeclared("Commodity Flow DAO: safeguard arcs encoded into communal consequence.");
    }
}
