// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BrandAlignmentCodex {
    address public overseer;
    uint256 public brandCount;

    struct BrandRule {
        uint256 id;
        string principle; // Identity, Consistency, Market Position, Player Trust
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BrandRule) public brands;

    event BrandLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBrand(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        brandCount++;
        brands[brandCount] = BrandRule({
            id: brandCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit BrandLogged(brandCount, principle, description);
    }

    function viewBrand(uint256 id) external view returns (BrandRule memory) {
        return brands[id];
    }
}
