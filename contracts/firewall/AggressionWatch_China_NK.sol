// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AggressionWatch_China_NK {
    address public steward = msg.sender;

    struct NationStatus {
        string name;
        bool isAggressive;
        bool aiAccessRevoked;
        uint256 lastAudit;
    }

    mapping(string => NationStatus) public watchlist;

    event AggressionDetected(string nation, string action, uint256 timestamp);
    event LicenseRevoked(string nation, string reason, uint256 timestamp);

    constructor() {
        watchlist["China"] = NationStatus("China", false, false, block.timestamp);
        watchlist["North Korea"] = NationStatus("North Korea", false, false, block.timestamp);
    }

    function reportAggression(string memory nation, string memory action) public {
        require(
            keccak256(bytes(nation)) == keccak256("China") || keccak256(bytes(nation)) == keccak256("North Korea"),
            "Nation not under watch."
        );

        watchlist[nation].isAggressive = true;
        watchlist[nation].aiAccessRevoked = true;
        watchlist[nation].lastAudit = block.timestamp;

        emit AggressionDetected(nation, action, block.timestamp);
        emit LicenseRevoked(nation, "AI weaponization or coercive aggression", block.timestamp);
    }

    function getNationStatus(string memory nation) public view returns (NationStatus memory) {
        return watchlist[nation];
    }
}
