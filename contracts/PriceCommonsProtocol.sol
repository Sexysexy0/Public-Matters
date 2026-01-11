pragma solidity ^0.8.20;

contract PriceCommonsProtocol {
    address public admin;

    struct Price {
        string item;         // e.g. RAM, GPU, motor part
        uint256 value;       // communal price
        uint256 timestamp;
    }

    Price[] public prices;

    event PriceLogged(string item, uint256 value, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPrice(string calldata item, uint256 value) external onlyAdmin {
        prices.push(Price(item, value, block.timestamp));
        emit PriceLogged(item, value, block.timestamp);
    }

    function totalPrices() external view returns (uint256) {
        return prices.length;
    }
}
