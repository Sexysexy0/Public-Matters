pragma solidity ^0.8.20;

contract EntropyWarProtocol {
    address public admin;

    struct Battle {
        string trade;        // e.g. Electrician, Plumber, Lineman
        string task;         // e.g. Fix leak, Wire socket
        uint256 timestamp;
    }

    Battle[] public battles;

    event BattleLogged(string trade, string task, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBattle(string calldata trade, string calldata task) external onlyAdmin {
        battles.push(Battle(trade, task, block.timestamp));
        emit BattleLogged(trade, task, block.timestamp);
    }

    function totalBattles() external view returns (uint256) {
        return battles.length;
    }
}
