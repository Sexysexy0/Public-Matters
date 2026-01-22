pragma solidity ^0.8.20;

contract SovereigntyDefenseProtocol {
    address public admin;

    struct Defense {
        string issue;        // e.g. Greenland sovereignty
        string stance;       // e.g. protect sovereignty, resist bullying
        string ally;         // e.g. NATO, Norway
        uint256 timestamp;
    }

    Defense[] public defenses;

    event DefenseLogged(string issue, string stance, string ally, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDefense(string calldata issue, string calldata stance, string calldata ally) external onlyAdmin {
        defenses.push(Defense(issue, stance, ally, block.timestamp));
        emit DefenseLogged(issue, stance, ally, block.timestamp);
    }

    function totalDefenses() external view returns (uint256) {
        return defenses.length;
    }
}
