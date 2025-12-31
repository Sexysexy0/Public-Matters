// contracts/CommunalConsequence.sol
pragma solidity ^0.8.20;

/**
 * @title CommunalConsequence
 * @notice Logs communal consequence protocols in healthcare systems.
 */
contract CommunalConsequence {
    address public admin;

    struct Protocol {
        string name;        // "SharedResponsibility", "Equity", "Resilience"
        string description;
        uint256 timestamp;
    }

    Protocol[] public protocols;

    event ProtocolLogged(string name, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logProtocol(string calldata name, string calldata description) external onlyAdmin {
        protocols.push(Protocol(name, description, block.timestamp));
        emit ProtocolLogged(name, description, block.timestamp);
    }
}
