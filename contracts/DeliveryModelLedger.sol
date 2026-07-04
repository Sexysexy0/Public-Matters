// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DeliveryModelLedger
/// @notice Encodes execution models (auto vs manual) for portfolio governance.
/// @dev Anchors rule-based vs human override execution modes.

contract DeliveryModelLedger {
    address public overseer;
    uint256 public modelCount;

    struct Model {
        uint256 id;
        string mode;        // Auto, Manual, Hybrid
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Model> public models;
    event ModelDeclared(uint256 indexed id, string mode, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareModel(string calldata mode, string calldata description) external onlyOverseer {
        modelCount++;
        models[modelCount] = Model(modelCount, mode, description, block.timestamp);
        emit ModelDeclared(modelCount, mode, description);
    }
}
