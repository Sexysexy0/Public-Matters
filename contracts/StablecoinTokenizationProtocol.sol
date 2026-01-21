pragma solidity ^0.8.20;

contract StablecoinTokenizationProtocol {
    address public admin;

    struct Tokenization {
        string sector;       // e.g. Wall Street dividends, corporate bonds
        string stablecoin;   // e.g. USDC, USDT
        string benefit;      // e.g. efficiency, transparency, liquidity
        uint256 timestamp;
    }

    Tokenization[] public tokenizations;

    event TokenizationLogged(string sector, string stablecoin, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTokenization(string calldata sector, string calldata stablecoin, string calldata benefit) external onlyAdmin {
        tokenizations.push(Tokenization(sector, stablecoin, benefit, block.timestamp));
        emit TokenizationLogged(sector, stablecoin, benefit, block.timestamp);
    }

    function totalTokenizations() external view returns (uint256) {
        return tokenizations.length;
    }
}
