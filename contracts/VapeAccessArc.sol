// contracts/VapeAccessArc.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VapeAccessArc
 * @notice Age-based exemption for vape access (25+ only).
 */
contract VapeAccessArc {
    address public admin;

    struct User {
        string name;
        uint16 birthYear;
        bool verified;
        bool registered;
    }

    struct Purchase {
        address buyer;
        string product;
        uint256 timestamp;
    }

    mapping(address => User) public users;
    Purchase[] public purchases;
    mapping(address => bool) public licensedRetailers;

    event UserRegistered(address indexed wallet, string name, uint16 birthYear, bool verified);
    event RetailerLicensed(address indexed retailer, bool status);
    event PurchaseLogged(address indexed buyer, string product, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyRetailer() {
        require(licensedRetailers[msg.sender], "Not licensed retailer");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Register user with birth year check
    function registerUser(address wallet, string calldata name, uint16 birthYear) external onlyAdmin {
        bool verified = (2025 - birthYear) >= 25;
        users[wallet] = User(name, birthYear, verified, true);
        emit UserRegistered(wallet, name, birthYear, verified);
    }

    // License retailers
    function setRetailer(address retailer, bool status) external onlyAdmin {
        licensedRetailers[retailer] = status;
        emit RetailerLicensed(retailer, status);
    }

    // Log purchase if verified and retailer is licensed
    function logPurchase(address buyer, string calldata product) external onlyRetailer {
        require(users[buyer].registered && users[buyer].verified, "Buyer not eligible");
        purchases.push(Purchase(buyer, product, block.timestamp));
        emit PurchaseLogged(buyer, product, block.timestamp);
    }

    // View helpers
    function totalPurchases() external view returns (uint256) {
        return purchases.length;
    }

    function getPurchase(uint256 id) external view returns (Purchase memory) {
        require(id < purchases.length, "Invalid purchase id");
        return purchases[id];
    }
}
