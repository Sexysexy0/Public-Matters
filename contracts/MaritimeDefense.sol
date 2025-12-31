// contracts/MaritimeDefense.sol
pragma solidity ^0.8.20;

/**
 * @title MaritimeDefense
 * @notice Logs maritime defense operations and patrols.
 */
contract MaritimeDefense {
    address public admin;

    struct Patrol {
        string zone;        // "PH Sea", "Taiwan Strait"
        string description;
        uint256 timestamp;
    }

    Patrol[] public patrols;

    event PatrolLogged(string zone, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logPatrol(string calldata zone, string calldata description) external onlyAdmin {
        patrols.push(Patrol(zone, description, block.timestamp));
        emit PatrolLogged(zone, description, block.timestamp);
    }
}
