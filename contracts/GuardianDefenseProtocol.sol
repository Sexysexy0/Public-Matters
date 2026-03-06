// GuardianDefenseProtocol.sol
pragma solidity ^0.8.0;

contract GuardianDefenseProtocol {
    struct Defense {
        uint256 id;
        string guardian;   // e.g. "Michael Archetype"
        string act;        // e.g. "Expel demonic influence"
        uint256 timestamp;
    }

    uint256 public defenseCount;
    mapping(uint256 => Defense) public defenses;

    event DefenseLogged(uint256 id, string guardian, string act);

    function logDefense(string memory guardian, string memory act) public {
        defenseCount++;
        defenses[defenseCount] = Defense(defenseCount, guardian, act, block.timestamp);
        emit DefenseLogged(defenseCount, guardian, act);
    }
}
