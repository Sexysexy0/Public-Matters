pragma solidity ^0.8.20;

contract CommodityBalanceProtocol {
    address public admin;

    struct Balance {
        string commodity;    // e.g. Gold, Silver, Oil
        uint256 allocation;  // percentage allocation
        string strategy;     // e.g. Hedge, Reserve
        uint256 timestamp;
    }

    Balance[] public balances;

    event BalanceLogged(string commodity, uint256 allocation, string strategy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBalance(string calldata commodity, uint256 allocation, string calldata strategy) external onlyAdmin {
        balances.push(Balance(commodity, allocation, strategy, block.timestamp));
        emit BalanceLogged(commodity, allocation, strategy, block.timestamp);
    }

    function totalBalances() external view returns (uint256) {
        return balances.length;
    }
}
