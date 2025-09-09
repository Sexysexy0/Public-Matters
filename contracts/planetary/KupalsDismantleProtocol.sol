// SPDX-License-Identifier: Treaty-Grade-License
pragma solidity ^0.8.0;

contract KupalsDismantleProtocol {
    address public steward;
    mapping(address => bool) public flaggedKupals;
    mapping(address => string) public reasonLogged;

    event KupalDetected(address indexed entity, string reason, uint timestamp);
    event KupalPurged(address indexed entity, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function flagKupal(address entity, string memory reason) public {
        require(msg.sender == steward, "Only steward can flag kupals");
        flaggedKupals[entity] = true;
        reasonLogged[entity] = reason;
        emit KupalDetected(entity, reason, block.timestamp);
    }

    function purgeKupal(address entity) public {
        require(flaggedKupals[entity], "Entity not flagged");
        flaggedKupals[entity] = false;
        delete reasonLogged[entity];
        emit KupalPurged(entity, block.timestamp);
    }

    function isKupal(address entity) public view returns (bool) {
        return flaggedKupals[entity];
    }

    function getKupalReason(address entity) public view returns (string memory) {
        return reasonLogged[entity];
    }
}
