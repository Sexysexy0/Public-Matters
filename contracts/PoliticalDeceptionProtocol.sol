pragma solidity ^0.8.20;

contract PoliticalDeceptionProtocol {
    address public admin;

    struct Deception {
        string spectrum;     // e.g. left, right
        string controller;   // e.g. hidden forces, corporations
        string message;      // e.g. "two wings of the same beast"
        uint256 timestamp;
    }

    Deception[] public deceptions;

    event DeceptionLogged(string spectrum, string controller, string message, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDeception(string calldata spectrum, string calldata controller, string calldata message) external onlyAdmin {
        deceptions.push(Deception(spectrum, controller, message, block.timestamp));
        emit DeceptionLogged(spectrum, controller, message, block.timestamp);
    }

    function totalDeceptions() external view returns (uint256) {
        return deceptions.length;
    }
}
