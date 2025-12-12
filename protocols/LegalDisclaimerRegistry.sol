// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LegalDisclaimerRegistry: store disclaimers and link them to content
contract LegalDisclaimerRegistry {
    struct Disclaimer {
        uint256 id;
        string label;      // e.g., "Opinion only", "Not legal advice"
        string textURI;    // URI to full disclaimer text
        bool active;
        uint256 timestamp;
    }

    struct Binding {
        uint256 id;
        string contentURI;
        uint256 disclaimerId;
        uint256 timestamp;
    }

    uint256 public nextDisclaimerId;
    uint256 public nextBindingId;
    mapping(uint256 => Disclaimer) public disclaimers;
    mapping(uint256 => Binding) public bindings;
    mapping(address => bool) public stewards;

    event DisclaimerSet(uint256 indexed id, string label, bool active);
    event DisclaimerBound(uint256 indexed bindingId, string contentURI, uint256 disclaimerId);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setDisclaimer(string calldata label, string calldata textURI, bool active) external {
        require(stewards[msg.sender], "Only steward");
        disclaimers[nextDisclaimerId] = Disclaimer(nextDisclaimerId, label, textURI, active, block.timestamp);
        emit DisclaimerSet(nextDisclaimerId, label, active);
        nextDisclaimerId++;
    }

    function bindDisclaimer(string calldata contentURI, uint256 disclaimerId) external {
        require(stewards[msg.sender], "Only steward");
        bindings[nextBindingId] = Binding(nextBindingId, contentURI, disclaimerId, block.timestamp);
        emit DisclaimerBound(nextBindingId, contentURI, disclaimerId);
        nextBindingId++;
    }
}
