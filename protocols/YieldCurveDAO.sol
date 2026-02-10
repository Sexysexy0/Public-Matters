// YieldCurveDAO.sol
pragma solidity ^0.8.0;

contract YieldCurveDAO {
    struct Control {
        uint256 id;
        string method;   // e.g. "Bond Buying", "Rate Cap"
        string status;   // e.g. "Active", "Proposed"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public controlCount;
    mapping(uint256 => Control) public controls;

    event ControlCreated(uint256 id, string method, string status);
    event ControlVoted(uint256 id, string method, bool support);
    event ControlResolved(uint256 id, string method);
    event YieldDeclared(string message);

    function createControl(string memory method, string memory status) public {
        controlCount++;
        controls[controlCount] = Control(controlCount, method, status, 0, 0, false);
        emit ControlCreated(controlCount, method, status);
    }

    function voteControl(uint256 id, bool support) public {
        if (support) {
            controls[id].votesFor++;
        } else {
            controls[id].votesAgainst++;
        }
        emit ControlVoted(id, controls[id].method, support);
    }

    function resolveControl(uint256 id) public {
        Control storage c = controls[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit ControlResolved(c.id, c.method);
    }

    function declareYield() public {
        emit YieldDeclared("Yield Curve DAO: safeguard arcs encoded into communal consequence.");
    }
}
