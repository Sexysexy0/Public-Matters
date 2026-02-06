// ETFInflowSignalDAO.sol
pragma solidity ^0.8.0;

contract ETFInflowSignalDAO {
    struct Flow {
        uint256 id;
        string fund;   // e.g. "IBIT", "ETH ETF"
        int256 netFlow; // positive = inflow, negative = outflow
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowCreated(uint256 id, string fund, int256 netFlow);
    event FlowVoted(uint256 id, string fund, bool support);
    event FlowPublished(uint256 id, string fund);
    event ETFDeclared(string message);

    function createFlow(string memory fund, int256 netFlow) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, fund, netFlow, 0, 0, false);
        emit FlowCreated(flowCount, fund, netFlow);
    }

    function voteFlow(uint256 id, bool support) public {
        if (support) {
            flows[id].votesFor++;
        } else {
            flows[id].votesAgainst++;
        }
        emit FlowVoted(id, flows[id].fund, support);
    }

    function publishFlow(uint256 id) public {
        Flow storage f = flows[id];
        require(!f.published, "Already published");
        require(f.votesFor > f.votesAgainst, "Not enough support");
        f.published = true;
        emit FlowPublished(f.id, f.fund);
    }

    function declareETF() public {
        emit ETFDeclared("ETF Inflow Signal DAO: safeguard arcs encoded into communal consequence.");
    }
}
