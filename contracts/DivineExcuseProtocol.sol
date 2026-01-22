pragma solidity ^0.8.20;

contract DivineExcuseProtocol {
    address public admin;

    struct Excuse {
        string context;      // e.g. divine authority, miracle
        string potential;    // e.g. shortcut reasoning
        string choice;       // e.g. avoided, used high-effort logic instead
        uint256 timestamp;
    }

    Excuse[] public excuses;

    event ExcuseLogged(string context, string potential, string choice, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExcuse(string calldata context, string calldata potential, string calldata choice) external onlyAdmin {
        excuses.push(Excuse(context, potential, choice, block.timestamp));
        emit ExcuseLogged(context, potential, choice, block.timestamp);
    }

    function totalExcuses() external view returns (uint256) {
        return excuses.length;
    }
}
