// contracts/RevenueImpact.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RevenueImpact
 * @notice Logs government revenue impact from VAT changes.
 */
contract RevenueImpact {
    address public admin;

    struct Impact {
        uint256 oldRate;
        uint256 newRate;
        uint256 estimatedLoss;
        string note;
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(uint256 oldRate, uint256 newRate, uint256 estimatedLoss, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logImpact(uint256 oldRate, uint256 newRate, uint256 estimatedLoss, string calldata note) external onlyAdmin {
        impacts.push(Impact(oldRate, newRate, estimatedLoss, note, block.timestamp));
        emit ImpactLogged(oldRate, newRate, estimatedLoss, note, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) { return impacts.length; }

    function getImpact(uint256 id) external view returns (Impact memory) {
        require(id < impacts.length, "Invalid id");
        return impacts[id];
    }
}
