// contracts/WalletSafety.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WalletSafety
 * @notice Logs wallet safety measures and communal protection protocols.
 */
contract WalletSafety {
    address public admin;

    struct Safety {
        string measure;     // "ColdStorage", "RevokeApprovals"
        string description;
        string status;      // "Implemented", "Pending"
        uint256 timestamp;
    }

    Safety[] public safeties;

    event SafetyLogged(string measure, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSafety(string calldata measure, string calldata description, string calldata status) external onlyAdmin {
        safeties.push(Safety(measure, description, status, block.timestamp));
        emit SafetyLogged(measure, description, status, block.timestamp);
    }

    function totalSafeties() external view returns (uint256) { return safeties.length; }

    function getSafety(uint256 id) external view returns (Safety memory) {
        require(id < safeties.length, "Invalid id");
        return safeties[id];
    }
}
