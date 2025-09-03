// AssetAuditLedgerCNRU.sol
pragma solidity ^0.8.19;

contract AssetAuditLedgerCNRU {
    address public steward;
    struct Asset {
        string jurisdiction;
        string assetType;
        string description;
        bool reclaimed;
        bool withdrawalDeclared;
    }

    Asset[] public assets;

    event AssetTagged(string jurisdiction, string assetType);
    event WithdrawalDeclared(string jurisdiction);

    constructor() {
        steward = msg.sender;
    }

    function tagAsset(string memory jurisdiction, string memory assetType, string memory description) public {
        require(msg.sender == steward, "Only steward may tag");
        assets.push(Asset(jurisdiction, assetType, description, false, false));
        emit AssetTagged(jurisdiction, assetType);
    }

    function declareWithdrawal(uint index) public {
        require(msg.sender == steward, "Only steward may withdraw");
        assets[index].withdrawalDeclared = true;
        emit WithdrawalDeclared(assets[index].jurisdiction);
    }

    function getAssets() public view returns (Asset[] memory) {
        return assets;
    }
}
