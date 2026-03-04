// DebugDAO.sol
pragma solidity ^0.8.0;

contract DebugDAO {
    struct Bug {
        uint256 id;
        string module;   // e.g. "Database Access"
        string detail;   // e.g. "Unhandled null pointer"
        bool fixed;
    }

    uint256 public bugCount;
    mapping(uint256 => Bug) public bugs;

    event BugLogged(uint256 id, string module, string detail);
    event BugFixed(uint256 id, string module);

    function logBug(string memory module, string memory detail) public {
        bugCount++;
        bugs[bugCount] = Bug(bugCount, module, detail, false);
        emit BugLogged(bugCount, module, detail);
    }

    function fixBug(uint256 id) public {
        bugs[id].fixed = true;
        emit BugFixed(id, bugs[id].module);
    }
}
