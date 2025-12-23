// contracts/TaxRelief.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TaxRelief
 * @notice Logs VAT rate changes and communal impact.
 */
contract TaxRelief {
    address public admin;

    struct VATChange {
        uint256 oldRate;
        uint256 newRate;
        string reason;
        uint256 timestamp;
    }

    VATChange[] public changes;

    event VATLogged(uint256 oldRate, uint256 newRate, string reason, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logVAT(uint256 oldRate, uint256 newRate, string calldata reason) external onlyAdmin {
        changes.push(VATChange(oldRate, newRate, reason, block.timestamp));
        emit VATLogged(oldRate, newRate, reason, block.timestamp);
    }

    function totalChanges() external view returns (uint256) { return changes.length; }

    function getChange(uint256 id) external view returns (VATChange memory) {
        require(id < changes.length, "Invalid id");
        return changes[id];
    }
}
