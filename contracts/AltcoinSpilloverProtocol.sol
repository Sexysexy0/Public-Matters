pragma solidity ^0.8.20;

contract AltcoinSpilloverProtocol {
    address public admin;

    struct Spillover {
        string asset;        // e.g. ZEC, DASH
        string change;       // e.g. -9.8%, -8.3%
        string trigger;      // e.g. BTC liquidation cascade
        uint256 timestamp;
    }

    Spillover[] public spillovers;

    event SpilloverLogged(string asset, string change, string trigger, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSpillover(string calldata asset, string calldata change, string calldata trigger) external onlyAdmin {
        spillovers.push(Spillover(asset, change, trigger, block.timestamp));
        emit SpilloverLogged(asset, change, trigger, block.timestamp);
    }

    function totalSpillovers() external view returns (uint256) {
        return spillovers.length;
    }
}
