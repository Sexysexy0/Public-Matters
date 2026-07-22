// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HRDDGovernance is Ownable {
    struct Report {
        uint256 id;
        string description;
        bool published;
        bool verified;
    }

    struct Risk {
        uint256 id;
        string region;
        string issue;
        bool mitigated;
    }

    Report[] public reports;
    Risk[] public risks;
    uint256 public reportCount;
    uint256 public riskCount;

    event ReportFiled(uint256 id, string description);
    event ReportVerified(uint256 id, bool verified);
    event RiskLogged(uint256 id, string region, string issue);
    event RiskMitigated(uint256 id, bool mitigated);

    constructor(address lead) Ownable(lead) {}

    function fileReport(string calldata _description) external onlyOwner {
        reportCount++;
        reports.push(Report(reportCount, _description, true, false));
        emit ReportFiled(reportCount, _description);
    }

    function verifyReport(uint256 _id) external onlyOwner {
        reports[_id - 1].verified = true;
        emit ReportVerified(_id, true);
    }

    function logRisk(string calldata _region, string calldata _issue) external onlyOwner {
        riskCount++;
        risks.push(Risk(riskCount, _region, _issue, false));
        emit RiskLogged(riskCount, _region, _issue);
    }

    function mitigateRisk(uint256 _id) external onlyOwner {
        risks[_id - 1].mitigated = true;
        emit RiskMitigated(_id, true);
    }
}
