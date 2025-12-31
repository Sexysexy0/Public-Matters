// contracts/SanctionProtocol.sol
pragma solidity ^0.8.20;

/**
 * @title SanctionProtocol
 * @notice Logs sanctions applied against adversarial actions.
 */
contract SanctionProtocol {
    address public admin;

    struct Sanction {
        string target;      // "Entity", "Country", "Corporation"
        string description;
        uint256 timestamp;
    }

    Sanction[] public sanctions;

    event SanctionLogged(string target, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logSanction(string calldata target, string calldata description) external onlyAdmin {
        sanctions.push(Sanction(target, description, block.timestamp));
        emit SanctionLogged(target, description, block.timestamp);
    }
}
