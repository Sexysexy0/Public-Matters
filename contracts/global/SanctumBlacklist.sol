// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumBlacklist {
    address public steward;
    mapping(string => bool) public blacklist;
    event SanctumBlacklisted(string sanctum);
    event SanctumUnblacklisted(string sanctum);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        blacklist["Russia"] = true;
        blacklist["China"] = true;
    }

    function blacklistSanctum(string memory sanctum) public onlySteward {
        blacklist[sanctum] = true;
        emit SanctumBlacklisted(sanctum);
    }

    function unblacklistSanctum(string memory sanctum) public onlySteward {
        blacklist[sanctum] = false;
        emit SanctumUnblacklisted(sanctum);
    }

    function isBlacklisted(string memory sanctum) public view returns (bool) {
        return blacklist[sanctum];
    }
}
