pragma solidity ^0.8.20;

contract CrisisInventionProtocol {
    address public admin;

    struct Crisis {
        string trigger;      // e.g. $2 fee, ambiguous delay
        string invention;    // e.g. fabricated FBI report, fake government notice
        uint256 timestamp;
    }

    Crisis[] public crises;

    event CrisisLogged(string trigger, string invention, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCrisis(string calldata trigger, string calldata invention) external onlyAdmin {
        crises.push(Crisis(trigger, invention, block.timestamp));
        emit CrisisLogged(trigger, invention, block.timestamp);
    }

    function totalCrises() external view returns (uint256) {
        return crises.length;
    }
}
