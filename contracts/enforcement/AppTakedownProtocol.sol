// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AppTakedownProtocol {
    struct LendingApp {
        string appName;
        string platform; // e.g. "Android", "iOS", "Web"
        string secRegNo;
        bool isLicensed;
        bool isGhost;
        string emotionalTag;
        uint256 timestamp;
    }

    LendingApp[] public apps;

    event AppFlagged(string appName, bool isGhost, string emotionalTag);

    function flagApp(
        string memory _appName,
        string memory _platform,
        string memory _secRegNo,
        bool _isLicensed,
        bool _isGhost,
        string memory _emotionalTag
    ) public {
        apps.push(LendingApp(_appName, _platform, _secRegNo, _isLicensed, _isGhost, _emotionalTag, block.timestamp));
        emit AppFlagged(_appName, _isGhost, _emotionalTag);
    }

    function totalApps() public view returns (uint256) {
        return apps.length;
    }
}
