// SPDX-License-Identifier: TheologySanctum
pragma solidity ^0.8.19;

contract TheologyOfWorkBroadcast {
    address public steward;

    struct Broadcast {
        address worker;
        string message;
        uint256 timestamp;
    }

    Broadcast[] public broadcasts;

    event BroadcastLogged(address indexed worker, string message, uint256 timestamp);

    function logBroadcast(address worker, string memory message) public {
        require(msg.sender == steward, "Only steward may broadcast");
        broadcasts.push(Broadcast(worker, message, block.timestamp));
        emit BroadcastLogged(worker, message, block.timestamp);
    }

    function getBroadcast(uint256 index) public view returns (address, string memory, uint256) {
        Broadcast memory b = broadcasts[index];
        return (b.worker, b.message, b.timestamp);
    }
}
