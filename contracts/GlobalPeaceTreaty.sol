// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalPeaceTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct Treaty {
        uint256 id;
        string nation;
        string commitment;
        uint256 timestamp;
    }

    mapping(uint256 => Treaty) public treaties;
    event TreatySigned(uint256 indexed id, string nation, string commitment);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function signTreaty(string calldata nation, string calldata commitment) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = Treaty(treatyCount, nation, commitment, block.timestamp);
        emit TreatySigned(treatyCount, nation, commitment);
    }
}
