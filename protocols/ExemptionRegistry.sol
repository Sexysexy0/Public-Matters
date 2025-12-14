// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ExemptionRegistry: record tax/VAT exemptions
contract ExemptionRegistry {
    struct Exemption {
        uint256 id;
        string item;        // "Rice", "Medicine", "School Supplies"
        string category;    // "Essential", "Health", "Education"
        bool zeroRated;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Exemption) public exemptions;
    mapping(address => bool) public stewards;

    event ExemptionLogged(uint256 indexed id, string item, string category);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logExemption(string calldata item, string calldata category, bool zeroRated) external {
        require(stewards[msg.sender], "Only steward");
        exemptions[nextId] = Exemption(nextId, item, category, zeroRated, block.timestamp);
        emit ExemptionLogged(nextId, item, category);
        nextId++;
    }
}
