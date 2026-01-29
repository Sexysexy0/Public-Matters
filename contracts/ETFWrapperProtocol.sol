pragma solidity ^0.8.20;

contract ETFWrapperProtocol {
    address public admin;

    struct ETF {
        string product;      // e.g. Spot Bitcoin ETF
        string provider;     // e.g. BlackRock, Fidelity
        uint256 allocation;  // percentage allocation
        uint256 timestamp;
    }

    ETF[] public etfs;

    event ETFLogged(string product, string provider, uint256 allocation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logETF(string calldata product, string calldata provider, uint256 allocation) external onlyAdmin {
        require(allocation <= 10, "Cap exceeded"); // 10% cap
        etfs.push(ETF(product, provider, allocation, block.timestamp));
        emit ETFLogged(product, provider, allocation, block.timestamp);
    }

    function totalETFs() external view returns (uint256) {
        return etfs.length;
    }
}
