// contracts/LegalAudit.sol
pragma solidity ^0.8.20;

contract LegalAudit {
    address public admin;

    struct Ruling {
        string court;       // "UNCLOS Tribunal", "International Court"
        string decision;
        uint256 timestamp;
    }

    Ruling[] public rulings;

    event RulingLogged(string court, string decision, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logRuling(string calldata court, string calldata decision) external onlyAdmin {
        rulings.push(Ruling(court, decision, block.timestamp));
        emit RulingLogged(court, decision, block.timestamp);
    }
}
