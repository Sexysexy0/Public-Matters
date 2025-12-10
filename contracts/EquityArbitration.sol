// contracts/EquityArbitration.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EquityArbitration
 * @notice Protocol for communal arbitration and equity distribution in disputes.
 */
contract EquityArbitration {
    address public admin;

    struct Arbitration {
        string dispute;
        string arbitrator;
        string decision;
        uint256 timestamp;
    }

    Arbitration[] public arbitrations;

    event ArbitrationLogged(string dispute, string arbitrator, string decision, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logArbitration(string calldata dispute, string calldata arbitrator, string calldata decision) external onlyAdmin {
        arbitrations.push(Arbitration(dispute, arbitrator, decision, block.timestamp));
        emit ArbitrationLogged(dispute, arbitrator, decision, block.timestamp);
    }

    function totalArbitrations() external view returns (uint256) {
        return arbitrations.length;
    }

    function getArbitration(uint256 id) external view returns (Arbitration memory) {
        require(id < arbitrations.length, "Invalid id");
        return arbitrations[id];
    }
}
