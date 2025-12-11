// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Petition Ledger Arc: immutable record of petitions filed
contract PetitionLedger {
    struct Petition {
        uint256 id;
        string subject;
        string evidenceURI;
        address filedBy;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Petition) public petitions;
    mapping(address => bool) public validators;
    address public steward;

    event PetitionFiled(uint256 indexed id, string subject);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address _validator) external {
        require(msg.sender == steward, "Only steward");
        validators[_validator] = true;
    }

    function filePetition(string calldata _subject, string calldata _evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        petitions[nextId] = Petition(nextId, _subject, _evidenceURI, msg.sender, block.timestamp);
        emit PetitionFiled(nextId, _subject);
        nextId++;
    }
}
