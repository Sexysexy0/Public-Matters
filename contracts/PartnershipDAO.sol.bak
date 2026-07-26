// PartnershipDAO.sol
pragma solidity ^0.8.0;

contract PartnershipDAO {
    struct Alliance {
        uint256 id;
        string partner;   // e.g. "Local Distributor"
        string detail;    // e.g. "Joint venture agreement"
        bool active;
    }

    uint256 public allianceCount;
    mapping(uint256 => Alliance) public alliances;

    event AllianceFormed(uint256 id, string partner, string detail);
    event AllianceActivated(uint256 id, string partner);

    function formAlliance(string memory partner, string memory detail) public {
        allianceCount++;
        alliances[allianceCount] = Alliance(allianceCount, partner, detail, false);
        emit AllianceFormed(allianceCount, partner, detail);
    }

    function activateAlliance(uint256 id) public {
        alliances[id].active = true;
        emit AllianceActivated(id, alliances[id].partner);
    }
}
