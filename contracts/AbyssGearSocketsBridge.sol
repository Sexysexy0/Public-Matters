// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AbyssGearSocketsBridge {
    struct GearSocket {
        address player;
        string gearType;
        uint256 slots;
        uint256 timestamp;
        bool safeguarded;
    }

    GearSocket[] public sockets;

    event SocketLogged(address indexed player, string gearType, uint256 slots);
    event SocketSafeguarded(uint256 indexed id, address verifier);

    function logSocket(string memory _gearType, uint256 _slots) public {
        sockets.push(GearSocket(msg.sender, _gearType, _slots, block.timestamp, false));
        emit SocketLogged(msg.sender, _gearType, _slots);
    }

    function safeguardSocket(uint256 _id) public {
        require(_id < sockets.length, "Invalid ID");
        sockets[_id].safeguarded = true;
        emit SocketSafeguarded(_id, msg.sender);
    }

    function getSocket(uint256 _id) public view returns (GearSocket memory) {
        require(_id < sockets.length, "Invalid ID");
        return sockets[_id];
    }

    function totalSockets() public view returns (uint256) {
        return sockets.length;
    }
}
