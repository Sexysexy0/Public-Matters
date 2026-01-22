pragma solidity ^0.8.20;

contract WasteEquityProtocol {
    address public admin;

    struct Equity {
        string sector;       // e.g. residential, commercial
        uint256 fee;         // e.g. 3000, 36000
        string fairness;     // e.g. equitable, disproportionate
        uint256 timestamp;
    }

    Equity[] public equities;

    event EquityLogged(string sector, uint256 fee, string fairness, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEquity(string calldata sector, uint256 fee, string calldata fairness) external onlyAdmin {
        equities.push(Equity(sector, fee, fairness, block.timestamp));
        emit EquityLogged(sector, fee, fairness, block.timestamp);
    }

    function totalEquities() external view returns (uint256) {
        return equities.length;
    }
}
