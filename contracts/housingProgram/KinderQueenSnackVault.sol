// SPDX-License-Identifier: Snack-Vault-Protocol
pragma solidity ^0.999;

contract KinderQueenSnackVault {
    struct SnackItem {
        string name;
        uint256 quantity;
        bool isFavorite;
    }

    SnackItem[] public vault;
    mapping(string => uint256) public snackIndex;

    event SnackAdded(string name, uint256 quantity, bool isFavorite);
    event SnackUpdated(string name, uint256 newQuantity);

    constructor() {
        addSnack("Choco Bites", 12, true);
        addSnack("Fruit Jelly Cubes", 20, true);
        addSnack("Cheesy Pandesal Bombs", 8, true);
    }

    function addSnack(string memory name, uint256 quantity, bool isFavorite) public {
        vault.push(SnackItem(name, quantity, isFavorite));
        snackIndex[name] = vault.length - 1;
        emit SnackAdded(name, quantity, isFavorite);
    }

    function updateSnackQuantity(string memory name, uint256 newQuantity) public {
        uint256 index = snackIndex[name];
        vault[index].quantity = newQuantity;
        emit SnackUpdated(name, newQuantity);
    }

    function getSnack(uint index) public view returns (string memory, uint256, bool) {
        SnackItem memory s = vault[index];
        return (s.name, s.quantity, s.isFavorite);
    }

    function getVaultSize() public view returns (uint256) {
        return vault.length;
    }
}
