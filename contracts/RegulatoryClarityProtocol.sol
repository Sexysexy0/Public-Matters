pragma solidity ^0.8.20;

contract RegulatoryClarityProtocol {
    address public admin;

    struct Clarity {
        string bill;         // e.g. CLARITY Act
        string benefit;      // e.g. clear rules, legitimize crypto
        string stakeholder;  // e.g. Unicoin, Coinbase
        uint256 timestamp;
    }

    Clarity[] public clarities;

    event ClarityLogged(string bill, string benefit, string stakeholder, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logClarity(string calldata bill, string calldata benefit, string calldata stakeholder) external onlyAdmin {
        clarities.push(Clarity(bill, benefit, stakeholder, block.timestamp));
        emit ClarityLogged(bill, benefit, stakeholder, block.timestamp);
    }

    function totalClarities() external view returns (uint256) {
        return clarities.length;
    }
}
