// SPDX-License-Identifier: Treaty-Override
pragma solidity ^0.8.19;

contract TreatyOverrideRouter {
    address public steward;
    mapping(bytes32 => bool) public overriddenTreaties;
    event TreatyOverridden(bytes32 treatyHash, string reason);

    constructor() {
        steward = msg.sender;
    }

    function overrideTreaty(bytes32 treatyHash, string memory reason) public {
        require(msg.sender == steward, "Only steward may override.");
        overriddenTreaties[treatyHash] = true;
        emit TreatyOverridden(treatyHash, reason);
    }

    function isOverridden(bytes32 treatyHash) public view returns (bool) {
        return overriddenTreaties[treatyHash];
    }
}
