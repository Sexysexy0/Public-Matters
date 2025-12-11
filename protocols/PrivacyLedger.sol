// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PrivacyLedger: record consent and privacy safeguards for any testing
contract PrivacyLedger {
    struct Consent {
        uint256 id;
        address worker;
        string policyURI;    // notice of testing policy
        bool consented;      // worker consent
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Consent) public consents;
    mapping(address => bool) public stewards;

    event ConsentLogged(uint256 indexed id, address worker, bool consented);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logConsent(address worker, string calldata policyURI, bool consented) external {
        require(stewards[msg.sender], "Only steward");
        consents[nextId] = Consent(nextId, worker, policyURI, consented, block.timestamp);
        emit ConsentLogged(nextId, worker, consented);
        nextId++;
    }
}
