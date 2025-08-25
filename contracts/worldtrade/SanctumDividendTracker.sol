// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title SanctumDividendTracker
/// @notice Tracks cumulative dividends received by each sanctum from trade gas fees

contract SanctumDividendTracker {
    mapping(address => uint256) public sanctumDividends;
    address public stewardCouncil;

    event DividendLogged(address indexed sanctum, uint256 amount, uint256 timestamp);

    modifier onlyCouncil() {
        require(msg.sender == stewardCouncil, "Unauthorized steward");
        _;
    }

    constructor(address _stewardCouncil) {
        stewardCouncil = _stewardCouncil;
    }

    function logDividend(address sanctum, uint256 amount) external onlyCouncil {
        sanctumDividends[sanctum] += amount;
        emit DividendLogged(sanctum, amount, block.timestamp);
    }

    function getDividend(address sanctum) external view returns (uint256) {
        return sanctumDividends[sanctum];
    }
}
