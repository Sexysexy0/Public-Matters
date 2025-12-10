// contracts/MythicDisputeResolution.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MythicDisputeResolution
 * @notice Mythic protocol for dispute resolution with communal audit.
 */
contract MythicDisputeResolution {
    address public admin;

    struct Dispute {
        string issue;
        string resolution;
        string mythicSeal; // symbolic validator-grade seal
        uint256 timestamp;
    }

    Dispute[] public disputes;

    event DisputeLogged(string issue, string resolution, string mythicSeal, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logDispute(string calldata issue, string calldata resolution, string calldata mythicSeal) external onlyAdmin {
        disputes.push(Dispute(issue, resolution, mythicSeal, block.timestamp));
        emit DisputeLogged(issue, resolution, mythicSeal, block.timestamp);
    }

    function totalDisputes() external view returns (uint256) {
        return disputes.length;
    }

    function getDispute(uint256 id) external view returns (Dispute memory) {
        require(id < disputes.length, "Invalid id");
        return disputes[id];
    }
}
