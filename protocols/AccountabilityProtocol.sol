// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Accountability Protocol Arc
// Immutable log for petitions, ceilings, SOCE declarations, and enforcement actions

contract AccountabilityProtocol {
    struct Case {
        uint256 id;
        string subject;      // e.g., "Escudero Donation", "Romualdez Term Limit", "SOCE Irregularity"
        string category;     // e.g., "Donation", "TermLimit", "PartyListCeiling", "SOCE"
        string evidenceURI;  // link to docs, petitions, or reports
        address filedBy;
        bool resolved;
        bool violationConfirmed;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Case) public cases;
    mapping(address => bool) public validators;
    address public steward;

    event CaseFiled(uint256 indexed id, string subject, string category);
    event CaseResolved(uint256 indexed id, bool violationConfirmed);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
    }

    function fileCase(string calldata _subject, string calldata _category, string calldata _evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        cases[nextId] = Case(nextId, _subject, _category, _evidenceURI, msg.sender, false, false, block.timestamp);
        emit CaseFiled(nextId, _subject, _category);
        nextId++;
    }

    function resolveCase(uint256 _id, bool _violationConfirmed) external {
        require(validators[msg.sender], "Not validator");
        require(!cases[_id].resolved, "Already resolved");
        cases[_id].resolved = true;
        cases[_id].violationConfirmed = _violationConfirmed;
        emit CaseResolved(_id, _violationConfirmed);
    }

    function getCase(uint256 _id) external view returns (Case memory) {
        return cases[_id];
    }
}
