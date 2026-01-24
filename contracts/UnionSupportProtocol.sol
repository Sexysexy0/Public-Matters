pragma solidity ^0.8.20;

contract UnionSupportProtocol {
    address public admin;

    struct UnionAction {
        string union;        // e.g. SEIU, local labor groups
        string action;       // e.g. strike backing, protest logistics
        string impact;       // e.g. shutdown scale, worker solidarity
        uint256 timestamp;
    }

    UnionAction[] public actions;

    event UnionActionLogged(string union, string action, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUnionAction(string calldata union, string calldata action, string calldata impact) external onlyAdmin {
        actions.push(UnionAction(union, action, impact, block.timestamp));
        emit UnionActionLogged(union, action, impact, block.timestamp);
    }

    function totalUnionActions() external view returns (uint256) {
        return actions.length;
    }
}
