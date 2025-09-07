// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketContractTemplate {
    string public steward = "Vinvin Gueco";
    uint public totalBudget = 100_000_000; // Example: ₱100M
    uint public releasedFunds = 0;

    mapping(uint => bool) public milestoneApproved;
    mapping(uint => string) public milestoneReport;

    event MilestoneUnlocked(uint milestone, uint amount, string report);

    function submitProgress(uint milestone, string memory report) public {
        require(milestone == 25 || milestone == 50 || milestone == 75 || milestone == 100, "Invalid milestone");
        require(!milestoneApproved[milestone], "Milestone already approved");

        milestoneApproved[milestone] = true;
        milestoneReport[milestone] = report;

        uint tranche = totalBudget / 4;
        releasedFunds += tranche;

        emit MilestoneUnlocked(milestone, tranche, report);
    }

    function auditStatus() public view returns (string memory) {
        return string(abi.encodePacked("Total released: ₱", uint2str(releasedFunds), " / ₱100M"));
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k--;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
