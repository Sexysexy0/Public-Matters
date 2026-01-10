pragma solidity ^0.8.20;

contract FundOriginProtocol {
    address public origin;

    struct Fund {
        string source;       // e.g. private sector, communal pool
        string purpose;      // e.g. infrastructure, health, education
        uint256 amount;
        uint256 timestamp;
    }

    Fund[] public funds;

    event FundLogged(string source, string purpose, uint256 amount, uint256 timestamp);

    constructor() { origin = msg.sender; }

    modifier onlyOrigin() { require(msg.sender == origin, "Not origin"); _; }

    function logFund(string calldata source, string calldata purpose, uint256 amount) external onlyOrigin {
        funds.push(Fund(source, purpose, amount, block.timestamp));
        emit FundLogged(source, purpose, amount, block.timestamp);
    }

    function totalFunds() external view returns (uint256) {
        return funds.length;
    }
}
