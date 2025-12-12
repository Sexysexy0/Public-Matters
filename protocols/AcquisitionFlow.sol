// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AcquisitionFlow: track orders, deliveries, and funding commitments
contract AcquisitionFlow {
    struct Order {
        uint256 id;
        uint256 platformId;
        uint256 quantity;
        uint256 budgetUsdMillions;
        string status; // "Planned", "Contracted", "In-Production", "Delivered"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Order) public orders;
    mapping(address => bool) public stewards;

    event OrderLogged(uint256 indexed id, uint256 platformId, uint256 quantity, string status);
    event OrderStatusUpdated(uint256 indexed id, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logOrder(
        uint256 platformId,
        uint256 quantity,
        uint256 budgetUsdMillions,
        string calldata status
    ) external {
        require(stewards[msg.sender], "Only steward");
        orders[nextId] = Order(nextId, platformId, quantity, budgetUsdMillions, status, block.timestamp);
        emit OrderLogged(nextId, platformId, quantity, status);
        nextId++;
    }

    function updateStatus(uint256 id, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        orders[id].status = status;
        emit OrderStatusUpdated(id, status);
    }
}
