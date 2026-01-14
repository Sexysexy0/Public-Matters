pragma solidity ^0.8.20;

contract AssetSafeguardProtocol {
    address public admin;

    struct Safeguard {
        string asset;        // e.g. deposits, securities, reserves
        string measure;      // e.g. insurance, custody, compliance
        uint256 timestamp;
    }

    Safeguard[] public safeguards;

    event SafeguardLogged(string asset, string measure, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSafeguard(string calldata asset, string calldata measure) external onlyAdmin {
        safeguards.push(Safeguard(asset, measure, block.timestamp));
        emit SafeguardLogged(asset, measure, block.timestamp);
    }

    function totalSafeguards() external view returns (uint256) {
        return safeguards.length;
    }
}
