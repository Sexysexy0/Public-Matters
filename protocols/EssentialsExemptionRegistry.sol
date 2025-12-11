// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EssentialsExemptionRegistry: list of goods/services exempted from VAT
contract EssentialsExemptionRegistry {
    struct Item {
        uint256 id;
        string name;       // e.g., "Rice", "Medicine", "School Supplies"
        bool exempt;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Item) public items;
    address public steward;

    event ItemRegistered(uint256 indexed id, string name, bool exempt);

    constructor() { steward = msg.sender; }

    function register(string calldata name, bool exempt) external {
        require(msg.sender == steward, "Only steward");
        items[nextId] = Item(nextId, name, exempt, block.timestamp);
        emit ItemRegistered(nextId, name, exempt);
        nextId++;
    }

    function toggle(uint256 id, bool exempt) external {
        require(msg.sender == steward, "Only steward");
        items[id].exempt = exempt;
    }
}
