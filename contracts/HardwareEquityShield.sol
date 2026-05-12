// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HardwareEquityShield {
    struct HardwareEvent {
        address participant;
        string device;
        string factor;
        uint256 timestamp;
        bool safeguarded;
    }

    HardwareEvent[] public events;

    event EventLogged(address indexed participant, string device, string factor);
    event EventSafeguarded(uint256 indexed id, address verifier);

    function logEvent(string memory _device, string memory _factor) public {
        events.push(HardwareEvent(msg.sender, _device, _factor, block.timestamp, false));
        emit EventLogged(msg.sender, _device, _factor);
    }

    function safeguardEvent(uint256 _id) public {
        require(_id < events.length, "Invalid ID");
        events[_id].safeguarded = true;
        emit EventSafeguarded(_id, msg.sender);
    }

    function getEvent(uint256 _id) public view returns (HardwareEvent memory) {
        require(_id < events.length, "Invalid ID");
        return events[_id];
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
