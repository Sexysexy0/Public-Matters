// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract RogueBuildJailProtocol {
    address public steward;

    struct JailRecord {
        string contractor;
        address wallet;
        string projectName;
        string violation;
        bool jailed;
        bool noBail;
        uint256 timestamp;
    }

    JailRecord[] public records;

    event RogueJailed(string contractor, string projectName, string violation);

    constructor() {
        steward = msg.sender;
    }

    function jailRogueBuilder(
        string memory contractor,
        address wallet,
        string memory projectName,
        string memory violation
    ) public {
        records.push(JailRecord(contractor, wallet, projectName, violation, true, true, block.timestamp));
        emit RogueJailed(contractor, projectName, violation);
    }

    function getJailRecord(uint256 index) public view returns (JailRecord memory) {
        return records[index];
    }

    function totalJailed() public view returns (uint256) {
        return records.length;
    }
}
