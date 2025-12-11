// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EssentialsGuard: define essentials and mark VAT-free / protected pricing
contract EssentialsGuard {
    struct Item {
        uint256 id;
        string name;           // e.g., "Rice", "Medicine", "School Supplies"
        bool vatFree;
        uint256 targetPrice;   // indicative fair price (optional)
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Item) public items;
    mapping(address => bool) public stewards;

    event ItemSet(uint256 indexed id, string name, bool vatFree, uint256 targetPrice);
    event ItemUpdated(uint256 indexed id, bool vatFree, uint256 targetPrice);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setItem(string calldata name, bool vatFree, uint256 targetPrice) external {
        require(stewards[msg.sender], "Only steward");
        items[nextId] = Item(nextId, name, vatFree, targetPrice, block.timestamp);
        emit ItemSet(nextId, name, vatFree, targetPrice);
        nextId++;
    }

    function updateItem(uint256 id, bool vatFree, uint256 targetPrice) external {
        require(stewards[msg.sender], "Only steward");
        Item storage it = items[id];
        it.vatFree = vatFree;
        it.targetPrice = targetPrice;
        emit ItemUpdated(id, vatFree, targetPrice);
    }
}
