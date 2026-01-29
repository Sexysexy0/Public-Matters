pragma solidity ^0.8.20;

contract MSMEProtocol {
    address public admin;

    struct MSME {
        string sector;       // e.g. Retail, Manufacturing
        string challenge;    // e.g. Credit access, Market competition
        uint256 timestamp;
    }

    MSME[] public msmes;

    event MSMELogged(string sector, string challenge, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMSME(string calldata sector, string calldata challenge) external onlyAdmin {
        msmes.push(MSME(sector, challenge, block.timestamp));
        emit MSMELogged(sector, challenge, block.timestamp);
    }

    function totalMSMEs() external view returns (uint256) {
        return msmes.length;
    }
}
