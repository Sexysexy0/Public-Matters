pragma solidity ^0.8.20;

contract InternetBlackoutProtocol {
    address public admin;

    struct Blackout {
        string region;       // e.g. Tehran, communal zone
        string status;       // e.g. active, lifted, partial
        uint256 timestamp;
    }

    Blackout[] public blackouts;

    event BlackoutLogged(string region, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBlackout(string calldata region, string calldata status) external onlyAdmin {
        blackouts.push(Blackout(region, status, block.timestamp));
        emit BlackoutLogged(region, status, block.timestamp);
    }

    function totalBlackouts() external view returns (uint256) {
        return blackouts.length;
    }
}
