pragma solidity ^0.8.20;

contract RetailInvestorProtocol {
    address public admin;

    struct Action {
        string asset;        // e.g. Bitcoin, altcoins, gold
        string behavior;     // e.g. diversify, accumulate, exit
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string asset, string behavior, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata asset, string calldata behavior) external onlyAdmin {
        actions.push(Action(asset, behavior, block.timestamp));
        emit ActionLogged(asset, behavior, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
