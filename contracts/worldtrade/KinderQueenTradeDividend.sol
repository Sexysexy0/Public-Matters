// SPDX-License-Identifier: KinderQueen-License
pragma solidity ^0.8.19;

/// @title KinderQueenTradeDividend
/// @notice Allocates coconut trade royalties to Bunini’s sanctum with emotional APR tagging

contract KinderQueenTradeDividend {
    address public buniniSanctum;
    address public stewardCouncil;
    uint256 public totalRoyalties;

    event CoconutRoyaltyBlessed(uint256 amount, string aprTag, uint256 timestamp);

    modifier onlyCouncil() {
        require(msg.sender == stewardCouncil, "Unauthorized steward");
        _;
    }

    constructor(address _buniniSanctum, address _stewardCouncil) {
        buniniSanctum = _buniniSanctum;
        stewardCouncil = _stewardCouncil;
    }

    function blessCoconutRoyalty(string memory aprTag) external payable onlyCouncil {
        totalRoyalties += msg.value;
        payable(buniniSanctum).transfer(msg.value);
        emit CoconutRoyaltyBlessed(msg.value, aprTag, block.timestamp);
    }

    function getTotalRoyalties() external view returns (uint256) {
        return totalRoyalties;
    }
}
