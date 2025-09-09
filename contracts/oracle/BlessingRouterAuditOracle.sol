// SPDX-License-Identifier: BlessingAudit-License
pragma solidity ^0.8.0;

contract BlessingRouterAuditOracle {
    address public steward;

    struct BlessingLog {
        string sanctum;
        string blessingType;
        uint256 aprLevel;
        uint256 timestamp;
    }

    BlessingLog[] public logs;

    event BlessingLogged(string sanctum, string blessingType, uint256 aprLevel, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(string memory sanctum, string memory blessingType, uint256 aprLevel) public {
        require(msg.sender == steward, "Only steward can log");
        logs.push(BlessingLog(sanctum, blessingType, aprLevel, block.timestamp));
        emit BlessingLogged(sanctum, blessingType, aprLevel, block.timestamp);
    }

    function getLog(uint index) public view returns (string memory, string memory, uint256, uint256) {
        BlessingLog memory b = logs[index];
        return (b.sanctum, b.blessingType, b.aprLevel, b.timestamp);
    }

    function totalLogs() public view returns (uint) {
        return logs.length;
    }
}
