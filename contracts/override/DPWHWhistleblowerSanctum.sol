// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract DPWHWhistleblowerSanctum {
    address public steward;

    struct Report {
        string summary;
        uint256 timestamp;
        bool isVerified;
    }

    mapping(address => Report[]) public reports;
    event ReportSubmitted(address indexed whistleblower, string summary);
    event ReportVerified(address indexed whistleblower, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized sanctum access.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function submitReport(string memory summary) public {
        reports[msg.sender].push(Report({
            summary: summary,
            timestamp: block.timestamp,
            isVerified: false
        }));

        emit ReportSubmitted(msg.sender, summary);
    }

    function verifyReport(address whistleblower, uint256 reportIndex) public onlySteward {
        require(reportIndex < reports[whistleblower].length, "Invalid report index.");
        reports[whistleblower][reportIndex].isVerified = true;

        emit ReportVerified(whistleblower, "Report verified. Audit triggered.");
    }

    function auditReport(address whistleblower, uint256 reportIndex) public view returns (string memory) {
        Report memory r = reports[whistleblower][reportIndex];
        return string(abi.encodePacked(
            "Summary: ", r.summary,
            " | Timestamp: ", uint2str(r.timestamp),
            " | Verified: ", r.isVerified ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
