// contracts/SubstanceSentinel.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SubstanceSentinel
 * @notice Unified age-based ledger for vape, alcohol, and tobacco.
 */
contract SubstanceSentinel {
    address public admin;

    struct User {
        string name;
        uint16 birthYear;
        bool verified;
    }

    struct Purchase {
        address buyer;
        string substance; // "vape", "alcohol", "tobacco"
        uint256 timestamp;
    }

    mapping(address => User) public users;
    Purchase[] public purchases;

    event UserRegistered(address indexed wallet, string name, uint16 birthYear, bool verified);
    event PurchaseLogged(address indexed buyer, string substance, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerUser(address wallet, string calldata name, uint16 birthYear) external onlyAdmin {
        bool verified = (2025 - birthYear) >= 18;
        users[wallet] = User(name, birthYear, verified);
        emit UserRegistered(wallet, name, birthYear, verified);
    }

    function logPurchase(address buyer, string calldata substance) external onlyAdmin {
        require(users[buyer].verified, "Not eligible");
        purchases.push(Purchase(buyer, substance, block.timestamp));
        emit PurchaseLogged(buyer, substance, block.timestamp);
    }
}
