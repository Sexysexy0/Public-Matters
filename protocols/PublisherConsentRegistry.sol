// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PublisherConsentRegistry: record publisher consents for AI training
contract PublisherConsentRegistry {
    struct Consent {
        uint256 id;
        string publisher;
        string dataset;
        bool granted;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Consent) public consents;
    mapping(address => bool) public stewards;

    event ConsentLogged(uint256 indexed id, string publisher, bool granted);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logConsent(string calldata publisher, string calldata dataset, bool granted) external {
        require(stewards[msg.sender], "Only steward");
        consents[nextId] = Consent(nextId, publisher, dataset, granted, block.timestamp);
        emit ConsentLogged(nextId, publisher, granted);
        nextId++;
    }
}
