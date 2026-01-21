pragma solidity ^0.8.20;

contract EconomicCollapseProtocol {
    address public admin;

    struct Collapse {
        string cause;        // e.g. recession, debt crisis, global instability
        string effect;       // e.g. bankruptcies, unemployment, poverty
        uint256 timestamp;
    }

    Collapse[] public collapses;

    event CollapseLogged(string cause, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCollapse(string calldata cause, string calldata effect) external onlyAdmin {
        collapses.push(Collapse(cause, effect, block.timestamp));
        emit CollapseLogged(cause, effect, block.timestamp);
    }

    function totalCollapses() external view returns (uint256) {
        return collapses.length;
    }
}
