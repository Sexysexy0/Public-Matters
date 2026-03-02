// InformationDAO.sol
pragma solidity ^0.8.0;

contract InformationDAO {
    struct Flow {
        uint256 id;
        string domain;    // e.g. "Training Data"
        string detail;    // e.g. "Redistribution vs creation of info"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowCreated(uint256 id, string domain, string detail);
    event FlowVoted(uint256 id, string domain, bool support);
    event FlowRatified(uint256 id, string domain);
    event InformationDeclared(string message);

    function createFlow(string memory domain, string memory detail) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, domain, detail, 0, 0, false);
        emit FlowCreated(flowCount, domain, detail);
    }

    function voteFlow(uint256 id, bool support) public {
        if (support) {
            flows[id].votesFor++;
        } else {
            flows[id].votesAgainst++;
        }
        emit FlowVoted(id, flows[id].domain, support);
    }

    function ratifyFlow(uint256 id) public {
        Flow storage f = flows[id];
        require(!f.ratified, "Already ratified");
        require(f.votesFor > f.votesAgainst, "Not enough support");
        f.ratified = true;
        emit FlowRatified(f.id, f.domain);
    }

    function declareInformation() public {
        emit InformationDeclared("Information DAO: safeguard arcs encoded into communal consequence.");
    }
}
