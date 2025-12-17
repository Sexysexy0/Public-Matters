// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// VendorLedger: record vendors and their stalls
contract VendorLedger {
    struct Vendor {
        uint256 id;
        string name;
        string product;     // "Pasalubong", "Gulay"
        string status;      // "Active", "Displaced"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Vendor) public vendors;
    mapping(address => bool) public stewards;

    event VendorLogged(uint256 indexed id, string name, string product, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logVendor(string calldata name, string calldata product, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        vendors[nextId] = Vendor(nextId, name, product, status, block.timestamp);
        emit VendorLogged(nextId, name, product, status);
        nextId++;
    }
}
