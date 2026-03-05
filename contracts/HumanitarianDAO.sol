// HumanitarianDAO.sol
pragma solidity ^0.8.0;

contract HumanitarianDAO {
    struct Initiative {
        uint256 id;
        string focus;   // e.g. "Civilian Protection"
        string detail;  // e.g. "Medical aid corridors"
        bool active;
    }

    uint256 public initiativeCount;
    mapping(uint256 => Initiative) public initiatives;

    event InitiativeActivated(uint256 id, string focus, string detail);

    function activateInitiative(string memory focus, string memory detail) public {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, focus, detail, true);
        emit InitiativeActivated(initiativeCount, focus, detail);
    }
}
