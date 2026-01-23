pragma solidity ^0.8.20;

contract GoodsAffordabilityProtocol {
    address public admin;

    struct Affordability {
        string product;      // e.g. rice, vegetables, meat
        string driver;       // e.g. cheaper transport, logistics
        string outcome;      // e.g. lower retail price
        uint256 timestamp;
    }

    Affordability[] public affordabilities;

    event AffordabilityLogged(string product, string driver, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAffordability(string calldata product, string calldata driver, string calldata outcome) external onlyAdmin {
        affordabilities.push(Affordability(product, driver, outcome, block.timestamp));
        emit AffordabilityLogged(product, driver, outcome, block.timestamp);
    }

    function totalAffordabilities() external view returns (uint256) {
        return affordabilities.length;
    }
}
