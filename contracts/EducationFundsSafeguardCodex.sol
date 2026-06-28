// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EducationFundsSafeguardCodex
/// @notice Covenant contract to safeguard education funds, procurement integrity, and classroom construction
contract EducationFundsSafeguardCodex {
    address public overseer;
    uint256 public fundCount;

    struct FundEntry {
        uint256 id;
        string category;
        string principle;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FundEntry) public fundEntries;

    event FundSafeguardLogged(uint256 indexed id, string category, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFund(
        string calldata category,
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        fundCount++;
        fundEntries[fundCount] = FundEntry({
            id: fundCount,
            category: category,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit FundSafeguardLogged(fundCount, category, principle);
    }

    function viewFund(uint256 id) external view returns (FundEntry memory) {
        return fundEntries[id];
    }
}
