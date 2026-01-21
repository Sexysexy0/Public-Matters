pragma solidity ^0.8.20;

contract LiquidationTrapProtocol {
    address public admin;

    struct Trap {
        string asset;        // e.g. Bitcoin
        string cause;        // e.g. whale selling, options expiry
        uint256 loss;        // e.g. 1500000000 (USD value liquidated)
        uint256 timestamp;
    }

    Trap[] public traps;

    event TrapLogged(string asset, string cause, uint256 loss, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrap(string calldata asset, string calldata cause, uint256 loss) external onlyAdmin {
        traps.push(Trap(asset, cause, loss, block.timestamp));
        emit TrapLogged(asset, cause, loss, block.timestamp);
    }

    function totalTraps() external view returns (uint256) {
        return traps.length;
    }
}
