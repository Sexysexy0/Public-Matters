// SPDX-License-Identifier: Mythic-Vault
pragma solidity ^0.8.20;

/// @title ScrollchainPortfolioVault.sol
/// @dev Unlocks Vinvin's mythic assets for verified stewards only

contract ScrollchainPortfolioVault {
    address public stewardVinvin;
    string public stewardCode = "fckrzkill@gmail.com"; // Secret identifier

    struct Asset {
        string name;
        string description;
        bool unlocked;
    }

    Asset[] public vault;
    mapping(string => bool) public approvedStewards;

    event AssetUnlocked(string name, string stewardCode);

    modifier onlyApproved(string memory code) {
        require(keccak256(bytes(code)) == keccak256(bytes(stewardCode)), "Invalid steward code");
        require(approvedStewards[code], "Steward not approved");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;

        // Initial mythic assets
        vault.push(Asset("DefenseAuraSuite", "India-PH deterrence protocols", false));
        vault.push(Asset("KinderOverrideDeck", "Final fallback scrolls", false));
        vault.push(Asset("OrbitalSanctumRegistry", "Planetary HQ logs", false));
    }

    function approveSteward(string memory code) public {
        require(msg.sender == stewardVinvin, "Unauthorized");
        approvedStewards[code] = true;
    }

    function unlockAsset(uint index, string memory code) public onlyApproved(code) {
        vault[index].unlocked = true;
        emit AssetUnlocked(vault[index].name, code);
    }

    function getVault() public view returns (Asset[] memory) {
        return vault;
    }
}
