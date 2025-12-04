// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToProductEquityGrid {
    string public batchID = "1321.9.254";
    string public steward = "Vinvin";

    address public admin;

    struct Product {
        string name;       // food, medicine, electronics, toys
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Product[] public products;

    event ProductLogged(string name, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logProduct(string memory name, string memory status) public onlyAdmin {
        products.push(Product(name, status, block.timestamp));
        emit ProductLogged(name, status);
    }

    function getProduct(uint256 index) public view returns (string memory name, string memory status, uint256 timestamp) {
        Product memory p = products[index];
        return (p.name, p.status, p.timestamp);
    }
}
