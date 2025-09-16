// SPDX-License-Identifier: AppealSanctum
pragma solidity ^0.8.19;

contract CreatorAppealSanctifier {
    struct AppealSignal {
        string contentHash;
        string creatorID;
        string appealReason;
        string moderationOutcome;
        bool resolved;
        string stewardNote;
    }

    mapping(string => AppealSignal) public appealRegistry;

    event AppealSubmitted(string contentHash, string creatorID);
    event AppealResolved(string contentHash);

    function submitAppeal(string memory contentHash, string memory creatorID, string memory appealReason, string memory moderationOutcome, string memory stewardNote) public {
        appealRegistry[contentHash] = AppealSignal(contentHash, creatorID, appealReason, moderationOutcome, false, stewardNote);
        emit AppealSubmitted(contentHash, creatorID);
    }

    function resolveAppeal(string memory contentHash) public {
        require(bytes(appealRegistry[contentHash].creatorID).length > 0, "Appeal not found");
        appealRegistry[contentHash].resolved = true;
        emit AppealResolved(contentHash);
    }

    function getAppealStatus(string memory contentHash) public view returns (AppealSignal memory) {
        return appealRegistry[contentHash];
    }
}
