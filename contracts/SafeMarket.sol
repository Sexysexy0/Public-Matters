// contracts/SafeMarket.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SafeMarket
 * @notice Ledger for protecting public markets as communal safe spaces.
 */
contract SafeMarket {
    address public admin;

    struct MarketDecision {
        string city;
        string proposal;   // e.g., "Modernization", "Preservation"
        string verdict;    // "Cancelled", "Approved", "Deferred"
        uint256 timestamp;
    }

    MarketDecision[] public decisions;

    event DecisionLogged(string city, string proposal, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDecision(string calldata city, string calldata proposal, string calldata verdict) external onlyAdmin {
        decisions.push(MarketDecision(city, proposal, verdict, block.timestamp));
        emit DecisionLogged(city, proposal, verdict, block.timestamp);
    }

    function totalDecisions() external view returns (uint256) { return decisions.length; }

    function getDecision(uint256 id) external view returns (MarketDecision memory) {
        require(id < decisions.length, "Invalid id");
        return decisions[id];
    }
}
