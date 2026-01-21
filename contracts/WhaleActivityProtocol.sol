pragma solidity ^0.8.20;

contract WhaleActivityProtocol {
    address public admin;

    struct WhaleMove {
        string asset;        // e.g. Bitcoin, Ethereum
        string action;       // e.g. aggressive selling, accumulation
        uint256 volume;      // e.g. 1500000000 (USD equivalent)
        uint256 timestamp;
    }

    WhaleMove[] public whaleMoves;

    event WhaleMoveLogged(string asset, string action, uint256 volume, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWhaleMove(string calldata asset, string calldata action, uint256 volume) external onlyAdmin {
        whaleMoves.push(WhaleMove(asset, action, volume, block.timestamp));
        emit WhaleMoveLogged(asset, action, volume, block.timestamp);
    }

    function totalWhaleMoves() external view returns (uint256) {
        return whaleMoves.length;
    }
}
