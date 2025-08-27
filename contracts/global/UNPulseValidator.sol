// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.27;

contract UNPulseValidator {
    address public steward;
    mapping(string => bool) public validatedBroadcasts;
    mapping(string => string) public validatorNotes;

    event BroadcastValidated(string scrollTag, string validatorNote);
    event GlobalEchoActivated(string scrollTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function validateBroadcast(string memory scrollTag, string memory note) external onlySteward {
        validatedBroadcasts[scrollTag] = true;
        validatorNotes[scrollTag] = note;
        emit BroadcastValidated(scrollTag, note);
    }

    function activateGlobalEcho(string memory scrollTag) external onlySteward {
        require(validatedBroadcasts[scrollTag], "Scroll not yet validated.");
        emit GlobalEchoActivated(scrollTag);
    }

    function isValidated(string memory scrollTag) external view returns (bool) {
        return validatedBroadcasts[scrollTag];
    }

    function getValidatorNote(string memory scrollTag) external view returns (string memory) {
        return validatorNotes[scrollTag];
    }
}
