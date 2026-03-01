// MinimalOSDAO.sol
pragma solidity ^0.8.0;

contract MinimalOSDAO {
    struct Module {
        uint256 id;
        string domain;    // e.g. "Operating System"
        string detail;    // e.g. "Remove bloatware, keep essentials"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public moduleCount;
    mapping(uint256 => Module) public modules;

    event ModuleCreated(uint256 id, string domain, string detail);
    event ModuleVoted(uint256 id, string domain, bool support);
    event ModuleRatified(uint256 id, string domain);
    event MinimalOSDeclared(string message);

    function createModule(string memory domain, string memory detail) public {
        moduleCount++;
        modules[moduleCount] = Module(moduleCount, domain, detail, 0, 0, false);
        emit ModuleCreated(moduleCount, domain, detail);
    }

    function voteModule(uint256 id, bool support) public {
        if (support) {
            modules[id].votesFor++;
        } else {
            modules[id].votesAgainst++;
        }
        emit ModuleVoted(id, modules[id].domain, support);
    }

    function ratifyModule(uint256 id) public {
        Module storage m = modules[id];
        require(!m.ratified, "Already ratified");
        require(m.votesFor > m.votesAgainst, "Not enough support");
        m.ratified = true;
        emit ModuleRatified(m.id, m.domain);
    }

    function declareMinimalOS() public {
        emit MinimalOSDeclared("Minimal OS DAO: safeguard arcs encoded into communal consequence.");
    }
}
