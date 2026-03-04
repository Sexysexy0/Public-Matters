// AuditFixDAO.sol
pragma solidity ^0.8.0;

contract AuditFixDAO {
    struct Report {
        uint256 id;
        string module;   // e.g. "Database Access"
        string issue;    // e.g. "Unhandled null pointer"
        bool resolved;
    }

    uint256 public reportCount;
    mapping(uint256 => Report) public reports;

    event ReportLogged(uint256 id, string module, string issue);
    event ReportResolved(uint256 id, string module);

    function logReport(string memory module, string memory issue) public {
        reportCount++;
        reports[reportCount] = Report(reportCount, module, issue, false);
        emit ReportLogged(reportCount, module, issue);
    }

    function resolveReport(uint256 id) public {
        reports[id].resolved = true;
        emit ReportResolved(id, reports[id].module);
    }
}
