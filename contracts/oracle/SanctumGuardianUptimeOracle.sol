// SPDX-License-Identifier: GuardianUptime-License
pragma solidity ^0.8.0;

contract SanctumGuardianUptimeOracle {
    address public steward;

    struct GuardianUptime {
        string guardian;
        string sanctumZone;
        uint256 uptimePercentage;
        string threatResponse;
        bool aprShielding;
        uint256 timestamp;
    }

    GuardianUptime[] public uptimes;

    event GuardianUptimeLogged(string guardian, string zone, uint uptime, string response, bool shielding, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logUptime(string memory guardian, string memory sanctumZone, uint256 uptimePercentage, string memory threatResponse, bool aprShielding) public {
        require(msg.sender == steward, "Only steward can log");
        uptimes.push(GuardianUptime(guardian, sanctumZone, uptimePercentage, threatResponse, aprShielding, block.timestamp));
        emit GuardianUptimeLogged(guardian, sanctumZone, uptimePercentage, threatResponse, aprShielding, block.timestamp);
    }

    function getUptime(uint index) public view returns (string memory, string memory, uint256, string memory, bool, uint256) {
        GuardianUptime memory u = uptimes[index];
        return (u.guardian, u.sanctumZone, u.uptimePercentage, u.threatResponse, u.aprShielding, u.timestamp);
    }
}
