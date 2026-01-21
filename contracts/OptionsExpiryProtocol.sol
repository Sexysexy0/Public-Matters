pragma solidity ^0.8.20;

contract OptionsExpiryProtocol {
    address public admin;

    struct Expiry {
        string asset;        // e.g. Bitcoin, Ethereum
        string scenario;     // e.g. June expiry trap, insurance hedge
        uint256 strikeLevel; // e.g. 75000
        uint256 timestamp;
    }

    Expiry[] public expiries;

    event ExpiryLogged(string asset, string scenario, uint256 strikeLevel, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpiry(string calldata asset, string calldata scenario, uint256 strikeLevel) external onlyAdmin {
        expiries.push(Expiry(asset, scenario, strikeLevel, block.timestamp));
        emit ExpiryLogged(asset, scenario, strikeLevel, block.timestamp);
    }

    function totalExpiries() external view returns (uint256) {
        return expiries.length;
    }
}
