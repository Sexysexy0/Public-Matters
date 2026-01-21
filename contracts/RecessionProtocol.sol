pragma solidity ^0.8.20;

contract RecessionProtocol {
    address public admin;

    struct Collapse {
        string trigger;      // e.g. economic downturn, financial crisis
        string impact;       // e.g. bankruptcies, poverty, instability
        uint256 timestamp;
    }

    Collapse[] public collapses;

    event CollapseLogged(string trigger, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCollapse(string calldata trigger, string calldata impact) external onlyAdmin {
        collapses.push(Collapse(trigger, impact, block.timestamp));
        emit CollapseLogged(trigger, impact, block.timestamp);
    }

    function totalCollapses() external view returns (uint256) {
        return collapses.length;
    }
}
