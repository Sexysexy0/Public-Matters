// HardAssetProtocol.sol
pragma solidity ^0.8.0;

contract HardAssetProtocol {
    struct Asset {
        uint256 id;
        string name;   // e.g. "Bitcoin", "Gold", "Real Estate"
        string role;   // e.g. "Safe Haven", "Store of Value"
        uint256 timestamp;
    }

    uint256 public assetCount;
    mapping(uint256 => Asset) public assets;

    event AssetLogged(uint256 id, string name, string role, uint256 timestamp);
    event HardDeclared(string message);

    function logAsset(string memory name, string memory role) public {
        assetCount++;
        assets[assetCount] = Asset(assetCount, name, role, block.timestamp);
        emit AssetLogged(assetCount, name, role, block.timestamp);
    }

    function declareHard() public {
        emit HardDeclared("Hard Asset Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
