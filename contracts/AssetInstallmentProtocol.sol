pragma solidity ^0.8.20;

contract AssetInstallmentProtocol {
    address public admin;

    struct Asset {
        string item;          // e.g. motorcycle, laptop, appliance
        uint256 monthlyPayment;
        string status;        // e.g. active, completed
        uint256 timestamp;
    }

    Asset[] public assets;

    event AssetLogged(string item, uint256 monthlyPayment, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAsset(string calldata item, uint256 monthlyPayment, string calldata status) external onlyAdmin {
        assets.push(Asset(item, monthlyPayment, status, block.timestamp));
        emit AssetLogged(item, monthlyPayment, status, block.timestamp);
    }

    function totalAssets() external view returns (uint256) {
        return assets.length;
    }
}
