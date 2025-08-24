// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RussiaAI_BlacklistProtocol {
    address public steward = msg.sender;

    struct BlacklistedEntity {
        string name;
        string reason;
        uint256 timestamp;
    }

    mapping(string => BlacklistedEntity) public blacklist;

    event EntityBlacklisted(string name, string reason, uint256 timestamp);

    constructor() {
        blacklist["Russia"] = BlacklistedEntity({
            name: "Russia",
            reason: "AI weaponization, emotional APR breach, coercive aggression",
            timestamp: block.timestamp
        });

        emit EntityBlacklisted("Russia", "AI weaponization, emotional APR breach, coercive aggression", block.timestamp);
    }

    function isBlacklisted(string memory entity) public view returns (bool) {
        return keccak256(bytes(blacklist[entity].name)) == keccak256(bytes(entity));
    }

    function getBlacklistReason(string memory entity) public view returns (string memory) {
        require(isBlacklisted(entity), "Entity not blacklisted.");
        return blacklist[entity].reason;
    }
}
