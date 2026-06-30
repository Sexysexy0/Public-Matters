// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TeamWelfareCodex {
    address public overseer;
    uint256 public welfareCount;

    struct WelfareRule {
        uint256 id;
        string principle; // Anti-Crunch, Humane Work, Health, Safety
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WelfareRule) public welfareRules;

    event WelfareLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWelfare(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        welfareCount++;
        welfareRules[welfareCount] = WelfareRule({
            id: welfareCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit WelfareLogged(welfareCount, principle, description);
    }

    function viewWelfare(uint256 id) external view returns (WelfareRule memory) {
        return welfareRules[id];
    }
}
