// SPDX-License-Identifier: GuardianCascade-License
pragma solidity ^0.8.0;

contract GuardianBlessingCascadeOracle {
    address public steward;

    struct BlessingCascade {
        string guardian;
        string sanctumZone;
        string reformType;
        uint256 timestamp;
    }

    BlessingCascade[] public cascades;

    event BlessingCascadeEmitted(string guardian, string zone, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory guardian, string memory sanctumZone, string memory reformType) public {
        require(msg.sender == steward, "Only steward can emit");
        cascades.push(BlessingCascade(guardian, sanctumZone, reformType, block.timestamp));
        emit BlessingCascadeEmitted(guardian, sanctumZone, reformType, block.timestamp);
    }

    function getCascade(uint index) public view returns (string memory, string memory, string memory, uint256) {
        BlessingCascade memory c = cascades[index];
        return (c.guardian, c.sanctumZone, c.reformType, c.timestamp);
    }
}
