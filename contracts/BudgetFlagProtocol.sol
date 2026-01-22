pragma solidity ^0.8.20;

contract BudgetFlagProtocol {
    address public admin;

    struct Flag {
        string project;      // e.g. streetlights, bleachers
        uint256 amount;      // e.g. 300000000
        string tag;          // e.g. OP, ES/SAP, BIN10
        uint256 timestamp;
    }

    Flag[] public flags;

    event FlagLogged(string project, uint256 amount, string tag, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFlag(string calldata project, uint256 amount, string calldata tag) external onlyAdmin {
        flags.push(Flag(project, amount, tag, block.timestamp));
        emit FlagLogged(project, amount, tag, block.timestamp);
    }

    function totalFlags() external view returns (uint256) {
        return flags.length;
    }
}
