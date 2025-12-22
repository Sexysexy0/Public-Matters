// contracts/InstitutionalGap.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InstitutionalGap
 * @notice Calculates the gap between institutional predictions and actual BTC prices.
 */
contract InstitutionalGap {
    address public admin;

    struct Gap {
        string institution;
        uint256 predicted;
        uint256 actual;
        int256 difference;
        uint256 timestamp;
    }

    Gap[] public gaps;

    event GapLogged(string institution, uint256 predicted, uint256 actual, int256 difference, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logGap(string calldata institution, uint256 predicted, uint256 actual) external onlyAdmin {
        int256 diff = int256(actual) - int256(predicted);
        gaps.push(Gap(institution, predicted, actual, diff, block.timestamp));
        emit GapLogged(institution, predicted, actual, diff, block.timestamp);
    }

    function totalGaps() external view returns (uint256) { return gaps.length; }

    function getGap(uint256 id) external view returns (Gap memory) {
        require(id < gaps.length, "Invalid id");
        return gaps[id];
    }
}
