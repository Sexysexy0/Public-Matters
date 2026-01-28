pragma solidity ^0.8.20;

contract LegalBattleProtocol {
    address public admin;

    struct Battle {
        string company;      // e.g. Unicoin
        string opponent;     // e.g. SEC
        string issue;        // e.g. compliance, listing on NYSE
        uint256 timestamp;
    }

    Battle[] public battles;

    event BattleLogged(string company, string opponent, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBattle(string calldata company, string calldata opponent, string calldata issue) external onlyAdmin {
        battles.push(Battle(company, opponent, issue, block.timestamp));
        emit BattleLogged(company, opponent, issue, block.timestamp);
    }

    function totalBattles() external view returns (uint256) {
        return battles.length;
    }
}
