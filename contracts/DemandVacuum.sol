// contracts/DemandVacuum.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DemandVacuum
 * @notice Tracks on-chain demand gaps and liquidity droughts.
 */
contract DemandVacuum {
    address public admin;

    struct Gap {
        string asset;       // "Bitcoin", "Ethereum"
        string description; // "Depleted order books", "ETF outflows"
        uint256 severity;   // scale 1-10
        uint256 timestamp;
    }

    Gap[] public gaps;

    event GapLogged(string asset, string description, uint256 severity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logGap(string calldata asset, string calldata description, uint256 severity) external onlyAdmin {
        gaps.push(Gap(asset, description, severity, block.timestamp));
        emit GapLogged(asset, description, severity, block.timestamp);
    }

    function totalGaps() external view returns (uint256) { return gaps.length; }

    function getGap(uint256 id) external view returns (Gap memory) {
        require(id < gaps.length, "Invalid id");
        return gaps[id];
    }
}
