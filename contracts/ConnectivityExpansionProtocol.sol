pragma solidity ^0.8.20;

contract ConnectivityExpansionProtocol {
    address public admin;

    struct Expansion {
        string mode;         // e.g. aviation, cargo, passenger
        string benefit;      // e.g. faster movement of people, goods, capital
        uint256 timestamp;
    }

    Expansion[] public expansions;

    event ExpansionLogged(string mode, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpansion(string calldata mode, string calldata benefit) external onlyAdmin {
        expansions.push(Expansion(mode, benefit, block.timestamp));
        emit ExpansionLogged(mode, benefit, block.timestamp);
    }

    function totalExpansions() external view returns (uint256) {
        return expansions.length;
    }
}
