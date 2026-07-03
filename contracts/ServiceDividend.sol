// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ServiceDividend
/// @notice Covenant to safeguard reinvestment dividends,
///         ensuring communities benefit from corporate surpluses.
contract ServiceDividend {
    address public overseer;
    uint256 public dividendCount;

    struct Dividend {
        uint256 id;
        string channel;     // CommunityPrograms, Jobs, Infrastructure, Education
        uint256 amount;
        uint256 timestamp;
    }

    mapping(uint256 => Dividend) public dividends;

    event DividendDeclared(uint256 indexed id, string channel, uint256 amount);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareDividend(string calldata channel, uint256 amount) external onlyOverseer {
        dividendCount++;
        dividends[dividendCount] = Dividend(dividendCount, channel, amount, block.timestamp);
        emit DividendDeclared(dividendCount, channel, amount);
    }

    function viewDividend(uint256 id) external view returns (Dividend memory) {
        return dividends[id];
    }
}
