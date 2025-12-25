// contracts/SovereigntyTransfer.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereigntyTransfer
 * @notice Tracks sovereignty transfers and communal dignity in territorial agreements.
 */
contract SovereigntyTransfer {
    address public admin;

    struct Transfer {
        string territory;   // "Chagos Archipelago"
        string fromEntity;  // "UK"
        string toEntity;    // "Mauritius"
        string status;      // "Completed", "Pending"
        uint256 timestamp;
    }

    Transfer[] public transfers;

    event TransferLogged(string territory, string fromEntity, string toEntity, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logTransfer(string calldata territory, string calldata fromEntity, string calldata toEntity, string calldata status) external onlyAdmin {
        transfers.push(Transfer(territory, fromEntity, toEntity, status, block.timestamp));
        emit TransferLogged(territory, fromEntity, toEntity, status, block.timestamp);
    }

    function totalTransfers() external view returns (uint256) { return transfers.length; }

    function getTransfer(uint256 id) external view returns (Transfer memory) {
        require(id < transfers.length, "Invalid id");
        return transfers[id];
    }
}
