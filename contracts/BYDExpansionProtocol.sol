pragma solidity ^0.8.20;

contract BYDExpansionProtocol {
    address public admin;

    struct Expansion {
        string region;       // e.g. Europe
        string growth;       // e.g. +268.6% sales
        string driver;       // e.g. affordability, aggressive rollout
        uint256 timestamp;
    }

    Expansion[] public expansions;

    event ExpansionLogged(string region, string growth, string driver, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpansion(string calldata region, string calldata growth, string calldata driver) external onlyAdmin {
        expansions.push(Expansion(region, growth, driver, block.timestamp));
        emit ExpansionLogged(region, growth, driver, block.timestamp);
    }

    function totalExpansions() external view returns (uint256) {
        return expansions.length;
    }
}
