// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InstitutionalTransparencyCodex {
    address public overseer;
    uint256 public reportCount;

    struct Report {
        uint256 id;
        string domain;       // Intelligence, Bureaucracy, Governance
        string principle;    // Transparency, Disclosure
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Report) public reports;
    event ReportDeclared(uint256 indexed id, string domain, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareReport(string calldata domain, string calldata principle, string calldata description) external onlyOverseer {
        reportCount++;
        reports[reportCount] = Report(reportCount, domain, principle, description, block.timestamp);
        emit ReportDeclared(reportCount, domain, principle, description);
    }
}
