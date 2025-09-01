// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GlobalReconnectionProtocol {
    struct ReconnectAct {
        string initiator;
        string counterpart;
        string gesture;
        uint256 empathy;
        uint256 humility;
        uint256 timestamp;
        bool accepted;
    }

    ReconnectAct[] public acts;

    event ReconnectAttempt(
        string initiator,
        string counterpart,
        string gesture,
        uint256 empathy,
        uint256 humility,
        uint256 timestamp,
        bool accepted
    );

    function initiateReconnect(
        string memory _initiator,
        string memory _counterpart,
        string memory _gesture,
        uint256 _empathy,
        uint256 _humility
    ) public {
        uint256 time = block.timestamp;
        bool accepted = (_empathy + _humility) > 150; // Threshold for genuine diplomacy

        acts.push(ReconnectAct(_initiator, _counterpart, _gesture, _empathy, _humility, time, accepted));
        emit ReconnectAttempt(_initiator, _counterpart, _gesture, _empathy, _humility, time, accepted);
    }

    function getAllAttempts() public view returns (ReconnectAct[] memory) {
        return acts;
    }
}
