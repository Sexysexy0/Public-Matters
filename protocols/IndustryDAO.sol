// IndustryDAO.sol
pragma solidity ^0.8.0;

contract IndustryDAO {
    struct Sector {
        uint256 id;
        string country;   // e.g. "China"
        string domain;    // e.g. "Manufacturing"
        uint256 share;    // e.g. 28 (%)
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public sectorCount;
    mapping(uint256 => Sector) public sectors;

    event SectorCreated(uint256 id, string country, string domain, uint256 share);
    event SectorVoted(uint256 id, string country, bool support);
    event SectorResolved(uint256 id, string country);
    event IndustryDeclared(string message);

    function createSector(string memory country, string memory domain, uint256 share) public {
        sectorCount++;
        sectors[sectorCount] = Sector(sectorCount, country, domain, share, 0, 0, false);
        emit SectorCreated(sectorCount, country, domain, share);
    }

    function voteSector(uint256 id, bool support) public {
        if (support) {
            sectors[id].votesFor++;
        } else {
            sectors[id].votesAgainst++;
        }
        emit SectorVoted(id, sectors[id].country, support);
    }

    function resolveSector(uint256 id) public {
        Sector storage s = sectors[id];
        require(!s.resolved, "Already resolved");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.resolved = true;
        emit SectorResolved(s.id, s.country);
    }

    function declareIndustry() public {
        emit IndustryDeclared("Industry DAO: safeguard arcs encoded into communal consequence.");
    }
}
