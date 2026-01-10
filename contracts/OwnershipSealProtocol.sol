pragma solidity ^0.8.20;

contract OwnershipSealProtocol {
    address public owner;

    struct Asset {
        string name;         // e.g. project, contract, property
        string status;       // e.g. owned, leased, communal
        uint256 timestamp;
    }

    Asset[] public assets;

    event AssetLogged(string name, string status, uint256 timestamp);

    constructor() { owner = msg.sender; }

    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }

    function logAsset(string calldata name, string calldata status) external onlyOwner {
        assets.push(Asset(name, status, block.timestamp));
        emit AssetLogged(name, status, block.timestamp);
    }

    function totalAssets() external view returns (uint256) {
        return assets.length;
    }
}
