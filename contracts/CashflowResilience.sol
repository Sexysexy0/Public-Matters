// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CashflowResilience
/// @notice Covenant contract to safeguard against paycheck trap by encoding asset-driven cashflow with AI leverage
contract CashflowResilience {
    address public owner;

    struct Cashflow {
        string source;       // e.g. "Rental Property", "Dividend Stock", "AI Business"
        uint256 baseIncome;  // original income from asset
        uint256 leverageFactor; // multiplier applied via AI leverage
        uint256 leveragedIncome; // computed income after leverage
        uint256 timestamp;
    }

    Cashflow[] public cashflows;

    event CashflowLogged(string source, uint256 baseIncome, uint256 leverageFactor, uint256 leveragedIncome, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new cashflow source with AI leverage
    function logCashflow(string memory source, uint256 baseIncome, uint256 leverageFactor) public onlyOwner {
        uint256 leveragedIncome = baseIncome * leverageFactor;
        Cashflow memory newCashflow = Cashflow(source, baseIncome, leverageFactor, leveragedIncome, block.timestamp);
        cashflows.push(newCashflow);
        emit CashflowLogged(source, baseIncome, leverageFactor, leveragedIncome, block.timestamp);
    }

    function getCashflow(uint256 index) public view returns (string memory, uint256, uint256, uint256, uint256) {
        Cashflow memory c = cashflows[index];
        return (c.source, c.baseIncome, c.leverageFactor, c.leveragedIncome, c.timestamp);
    }

    function getCashflowCount() public view returns (uint256) {
        return cashflows.length;
    }
}
