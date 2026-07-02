// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyMirror {
    address public overseer;
    uint256 public reportCount;

    struct Report {
        uint256 id;
        string subject;
        string content;
        uint256 timestamp;
    }

    mapping(uint256 => Report) public reports;
    event ReportPublished(uint256 indexed id, string subject, string content);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function publishReport(string calldata subject, string calldata content) external onlyOverseer {
        reportCount++;
        reports[reportCount] = Report(reportCount, subject, content, block.timestamp);
        emit ReportPublished(reportCount, subject, content);
    }
}
