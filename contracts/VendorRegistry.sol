// contracts/VendorRegistry.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VendorRegistry
 * @notice Optional registry to track displaced vendors and their assigned relocation projects.
 */
contract VendorRegistry {
    address public admin;

    struct Vendor {
        address wallet;
        string name;
        string originalMarket;
        string displacementReason; // "Modernization", "Demolition"
        uint256 assignedProjectId; // RelocationMarket project id or type mapping externally
        uint256 timestamp;
    }

    Vendor[] public vendors;

    event VendorLogged(
        address indexed wallet,
        string name,
        string originalMarket,
        string displacementReason,
        uint256 assignedProjectId,
        uint256 timestamp
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logVendor(
        address wallet,
        string calldata name,
        string calldata originalMarket,
        string calldata displacementReason,
        uint256 assignedProjectId
    ) external onlyAdmin {
        vendors.push(Vendor(wallet, name, originalMarket, displacementReason, assignedProjectId, block.timestamp));
        emit VendorLogged(wallet, name, originalMarket, displacementReason, assignedProjectId, block.timestamp);
    }

    function totalVendors() external view returns (uint256) {
        return vendors.length;
    }

    function getVendor(uint256 id) external view returns (Vendor memory) {
        require(id < vendors.length, "Invalid id");
        return vendors[id];
    }
}
