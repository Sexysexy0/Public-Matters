// InflationControlDAO.sol
pragma solidity ^0.8.0;

contract InflationControlDAO {
    struct Control {
        uint256 id;
        string tool;     // e.g. "Interest Rates", "Money Supply"
        string status;   // e.g. "Active", "Inactive"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public controlCount;
    mapping(uint256 => Control) public controls;

    event ControlCreated(uint256 id, string tool, string status);
    event ControlVoted(uint256 id, string tool, bool support);
    event ControlResolved(uint256 id, string tool);
    event InflationDeclared(string message);

    function createControl(string memory tool, string memory status) public {
        controlCount++;
        controls[controlCount] = Control(controlCount, tool, status, 0, 0, false);
        emit ControlCreated(controlCount, tool, status);
    }

    function voteControl(uint256 id, bool support) public {
        if (support) {
            controls[id].votesFor++;
        } else {
            controls[id].votesAgainst++;
        }
        emit ControlVoted(id, controls[id].tool, support);
    }

    function resolveControl(uint256 id) public {
        Control storage c = controls[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit ControlResolved(c.id, c.tool);
    }

    function declareInflation() public {
        emit InflationDeclared("Inflation Control DAO: safeguard arcs encoded into communal consequence.");
    }
}
