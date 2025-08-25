// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumFirewallProtocol {
    address public steward;
    mapping(address => bool) public trustedSanctums;
    mapping(address => bool) public revokedEntities;

    event SanctumRevoked(address indexed entity, string reason, uint256 timestamp);
    event ScholarFlowRevoked(address indexed scholar, string originTag, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function revokeSanctum(address entity, string memory reason) public onlySteward {
        revokedEntities[entity] = true;
        emit SanctumRevoked(entity, reason, block.timestamp);
    }

    function revokeScholarFlow(address scholar, string memory originTag) public onlySteward {
        require(compareStrings(originTag, "CCP"), "Only CCP-linked scholars can be revoked");
        emit ScholarFlowRevoked(scholar, originTag, block.timestamp);
    }

    function isRevoked(address entity) public view returns (bool) {
        return revokedEntities[entity];
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
