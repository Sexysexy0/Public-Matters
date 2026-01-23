pragma solidity ^0.8.20;

contract EconomicEquityProtocol {
    address public admin;

    struct Equity {
        string group;        // e.g. minimum wage earners, transport workers
        string measure;      // e.g. fuel subsidy, price control
        string benefit;      // e.g. fair access, affordability
        uint256 timestamp;
    }

    Equity[] public equities;

    event EquityLogged(string group, string measure, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEquity(string calldata group, string calldata measure, string calldata benefit) external onlyAdmin {
        equities.push(Equity(group, measure, benefit, block.timestamp));
        emit EquityLogged(group, measure, benefit, block.timestamp);
    }

    function totalEquities() external view returns (uint256) {
        return equities.length;
    }
}
