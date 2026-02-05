// ProtocolEvolutionDAO.sol
pragma solidity ^0.8.0;

contract ProtocolEvolutionDAO {
    struct Upgrade {
        uint256 id;
        string feature;   // e.g. "Consensus Improvement", "Scalability Patch"
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public upgradeCount;
    mapping(uint256 => Upgrade) public upgrades;

    event UpgradeCreated(uint256 id, string feature, string description);
    event UpgradeVoted(uint256 id, string feature, bool support);
    event UpgradeEnacted(uint256 id, string feature);
    event EvolutionDeclared(string message);

    function createUpgrade(string memory feature, string memory description) public {
        upgradeCount++;
        upgrades[upgradeCount] = Upgrade(upgradeCount, feature, description, 0, 0, false);
        emit UpgradeCreated(upgradeCount, feature, description);
    }

    function voteUpgrade(uint256 id, bool support) public {
        if (support) {
            upgrades[id].votesFor++;
        } else {
            upgrades[id].votesAgainst++;
        }
        emit UpgradeVoted(id, upgrades[id].feature, support);
    }

    function enactUpgrade(uint256 id) public {
        Upgrade storage u = upgrades[id];
        require(!u.enacted, "Already enacted");
        require(u.votesFor > u.votesAgainst, "Not enough support");
        u.enacted = true;
        emit UpgradeEnacted(u.id, u.feature);
    }

    function declareEvolution() public {
        emit EvolutionDeclared("Protocol Evolution DAO: upgrade arcs encoded into communal consequence.");
    }
}
