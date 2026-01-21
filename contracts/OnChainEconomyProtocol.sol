pragma solidity ^0.8.20;

contract OnChainEconomyProtocol {
    address public admin;

    struct Economy {
        string country;      // e.g. nation adopting USDC
        string feature;      // e.g. fully on-chain, hidden catch
        uint256 timestamp;
    }

    Economy[] public economies;

    event EconomyLogged(string country, string feature, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEconomy(string calldata country, string calldata feature) external onlyAdmin {
        economies.push(Economy(country, feature, block.timestamp));
        emit EconomyLogged(country, feature, block.timestamp);
    }

    function totalEconomies() external view returns (uint256) {
        return economies.length;
    }
}
