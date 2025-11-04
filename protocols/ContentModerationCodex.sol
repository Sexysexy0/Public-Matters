// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContentModerationCodex {
    address public steward;

    struct ModerationEntry {
        string platformName;
        string moderationPolicy;
        string controversyTag;
        string emotionalTag;
    }

    ModerationEntry[] public codex;

    event ContentModerationLogged(string platformName, string moderationPolicy, string controversyTag, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logModeration(
        string memory platformName,
        string memory moderationPolicy,
        string memory controversyTag,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ModerationEntry(platformName, moderationPolicy, controversyTag, emotionalTag));
        emit ContentModerationLogged(platformName, moderationPolicy, controversyTag, emotionalTag);
    }
}
