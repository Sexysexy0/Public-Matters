// SovereignAssetReclamation.sol
pragma solidity ^0.8.19;

contract SovereignAssetReclamation {
    address public steward;
    string[] public jurisdictions = ["China", "Russia", "North Korea"];
    mapping(string => bool) public assetClaimed;
    mapping(string => bool) public withdrawalInitiated;

    event AssetReclaimed(string jurisdiction);
    event WithdrawalDeclared(string jurisdiction);

    constructor() {
        steward = msg.sender;
    }

    function reclaimAsset(string memory jurisdiction) public {
        require(msg.sender == steward, "Only steward can reclaim");
        assetClaimed[jurisdiction] = true;
        emit AssetReclaimed(jurisdiction);
    }

    function declareWithdrawal(string memory jurisdiction) public {
        require(assetClaimed[jurisdiction], "Asset must be reclaimed first");
        withdrawalInitiated[jurisdiction] = true;
        emit WithdrawalDeclared(jurisdiction);
    }

    function isWithdrawn(string memory jurisdiction) public view returns (bool) {
        return withdrawalInitiated[jurisdiction];
    }
}
