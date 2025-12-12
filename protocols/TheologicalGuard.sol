// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TheologicalGuard: record theological justifications and flag them
contract TheologicalGuard {
    struct Justification {
        uint256 id;
        string source;     // e.g., "Ted Cruz speech"
        string claim;      // e.g., "Bible mandates support"
        bool valid;        // flagged as valid or not
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Justification) public justifications;
    mapping(address => bool) public stewards;

    event JustificationLogged(uint256 indexed id, string source, bool valid);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logJustification(string calldata source, string calldata claim, bool valid) external {
        require(stewards[msg.sender], "Only steward");
        justifications[nextId] = Justification(nextId, source, claim, valid, block.timestamp);
        emit JustificationLogged(nextId, source, valid);
        nextId++;
    }
}
