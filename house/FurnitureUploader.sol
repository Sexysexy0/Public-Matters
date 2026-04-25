// [Goal: Link furniture visual upgrades to gameplay buffs]
function upgradeFurniture(string memory _itemType) external pure returns (uint256 _buffPower) {
    if (keccak256(abi.encodePacked(_itemType)) == keccak256(abi.encodePacked("Royal_Bed"))) {
        return 200; // 2x Stamina Recovery
    }
    return 100;
}
