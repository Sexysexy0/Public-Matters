// SPDX-License-Identifier: Scrollchain-Water
pragma solidity ^0.8.0;

contract WaterRecoveryDeck {
    address public steward;
    uint public totalRecoveries;

    struct RecoveryEvent {
        string region;
        string method; // e.g., "Desalination", "Greywater Recycling"
        uint litersRecovered;
        uint timestamp;
    }

    RecoveryEvent[] public recoveryLog;

    event RecoveryLogged(string region, string method, uint litersRecovered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logRecovery(string memory region, string memory method, uint litersRecovered) public {
        require(msg.sender == steward, "Access denied");
        recoveryLog.push(RecoveryEvent(region, method, litersRecovered, block.timestamp));
        totalRecoveries += 1;
        emit RecoveryLogged(region, method, litersRecovered, block.timestamp);
    }

    function getLatestRecovery() public view returns (RecoveryEvent memory) {
        require(recoveryLog.length > 0, "No recoveries logged");
        return recoveryLog[recoveryLog.length - 1];
    }
}
