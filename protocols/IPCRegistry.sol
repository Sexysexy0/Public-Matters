// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// IPCRegistry: register cases and petitions under the Independent Peoples Commission
contract IPCRegistry {
    struct Petition {
        uint256 id;
        string subject;
        string evidenceURI;
        address filedBy;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Petition) public petitions;
    address public steward;

    event PetitionFiled(uint256 indexed id, string subject);

    constructor() { steward = msg.sender; }

    function filePetition(string calldata subject, string calldata evidenceURI) external {
        petitions[nextId] = Petition(nextId, subject, evidenceURI, msg.sender, block.timestamp);
        emit PetitionFiled(nextId, subject);
        nextId++;
    }
}
