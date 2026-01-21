pragma solidity ^0.8.20;

contract PersecutionMadnessProtocol {
    address public admin;

    struct Persecution {
        string target;       // e.g. Spirit-filled Christians, evangelical projects
        string method;       // e.g. harassment, media attacks, government restrictions
        uint256 timestamp;
    }

    Persecution[] public persecutions;

    event PersecutionLogged(string target, string method, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPersecution(string calldata target, string calldata method) external onlyAdmin {
        persecutions.push(Persecution(target, method, block.timestamp));
        emit PersecutionLogged(target, method, block.timestamp);
    }

    function totalPersecutions() external view returns (uint256) {
        return persecutions.length;
    }
}
