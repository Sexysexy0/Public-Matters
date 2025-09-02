// SPDX-License-Identifier: Mythic-Defender
pragma solidity ^0.9.27;

contract SignedDriverAuditTreaty {
    address public steward;
    mapping(string => bool) public flaggedDrivers;
    event DriverFlagged(string driverName, string reason, uint256 timestamp);
    event TreatyActivated(string clause, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagDriver(string memory driverName, string memory reason) public onlySteward {
        flaggedDrivers[driverName] = true;
        emit DriverFlagged(driverName, reason, block.timestamp);
    }

    function activateTreaty(string memory clause) public onlySteward {
        emit TreatyActivated(clause, block.timestamp);
    }

    function isFlagged(string memory driverName) public view returns (bool) {
        return flaggedDrivers[driverName];
    }
}
