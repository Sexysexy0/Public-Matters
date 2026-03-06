// CommunityAuditRightsDAO.sol
pragma solidity ^0.8.0;

contract CommunityAuditRightsDAO {
    struct Request {
        uint256 id;
        string citizen;   // e.g. "Barangay Auditor"
        string report;    // e.g. "Transparency Report Request"
        bool fulfilled;
    }

    uint256 public requestCount;
    mapping(uint256 => Request) public requests;

    event RequestFiled(uint256 id, string citizen, string report);

    function fileRequest(string memory citizen, string memory report) public {
        requestCount++;
        requests[requestCount] = Request(requestCount, citizen, report, false);
        emit RequestFiled(requestCount, citizen, report);
    }

    function fulfillRequest(uint256 id) public {
        requests[id].fulfilled = true;
    }
}
