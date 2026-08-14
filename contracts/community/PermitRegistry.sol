// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PermitRegistry {
    struct Permit {
        bytes32 documentHash;
        string description;
        uint256 timestamp;
        address submitter;
        bool isDisclosed;
    }

    mapping(bytes32 => Permit) public permits;
    bytes32[] public permitIds;

    event PermitSubmitted(bytes32 indexed permitId, string description);
    event PermitDisclosed(bytes32 indexed permitId);

    function submitPermit(bytes32 _permitId, string memory _description, bytes32 _documentHash) external {
        require(permits[_permitId].submitter == address(0), "Permit already exists");
        permits[_permitId] = Permit({
            documentHash: _documentHash,
            description: _description,
            timestamp: block.timestamp,
            submitter: msg.sender,
            isDisclosed: false
        });
        permitIds.push(_permitId);
        emit PermitSubmitted(_permitId, _description);
    }

    function disclosePermit(bytes32 _permitId) external {
        permits[_permitId].isDisclosed = true;
        emit PermitDisclosed(_permitId);
    }

    function getPermit(bytes32 _permitId) external view returns (Permit memory) {
        return permits[_permitId];
    }
}
