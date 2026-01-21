pragma solidity ^0.8.20;

contract MediaAttackProtocol {
    address public admin;

    struct Attack {
        string medium;       // e.g. Hollywood, TV comedies, news outlets
        string method;       // e.g. ridicule, distortion, harassment
        uint256 timestamp;
    }

    Attack[] public attacks;

    event AttackLogged(string medium, string method, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAttack(string calldata medium, string calldata method) external onlyAdmin {
        attacks.push(Attack(medium, method, block.timestamp));
        emit AttackLogged(medium, method, block.timestamp);
    }

    function totalAttacks() external view returns (uint256) {
        return attacks.length;
    }
}
