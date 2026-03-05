// IntegrityDAO.sol
pragma solidity ^0.8.0;

contract IntegrityDAO {
    struct Check {
        uint256 id;
        string system;   // e.g. "Financial Ledger"
        string detail;   // e.g. "Double-entry verification"
        bool passed;
    }

    uint256 public checkCount;
    mapping(uint256 => Check) public checks;

    event CheckLogged(uint256 id, string system, string detail);
    event CheckPassed(uint256 id, string system);

    function logCheck(string memory system, string memory detail) public {
        checkCount++;
        checks[checkCount] = Check(checkCount, system, detail, false);
        emit CheckLogged(checkCount, system, detail);
    }

    function passCheck(uint256 id) public {
        checks[id].passed = true;
        emit CheckPassed(id, checks[id].system);
    }
}
