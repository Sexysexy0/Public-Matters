pragma solidity ^0.8.20;

contract LiquidationCascadeProtocol {
    address public admin;

    struct Cascade {
        string asset;        // e.g. BTC, ZEC, DASH
        string value;        // e.g. $146M liquidations
        string detail;       // e.g. 98% longs, forced selling
        uint256 timestamp;
    }

    Cascade[] public cascades;

    event CascadeLogged(string asset, string value, string detail, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCascade(string calldata asset, string calldata value, string calldata detail) external onlyAdmin {
        cascades.push(Cascade(asset, value, detail, block.timestamp));
        emit CascadeLogged(asset, value, detail, block.timestamp);
    }

    function totalCascades() external view returns (uint256) {
        return cascades.length;
    }
}
