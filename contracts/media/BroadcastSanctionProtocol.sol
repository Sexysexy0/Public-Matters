// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BroadcastSanctionProtocol {
    struct MediaEntity {
        string entityId;
        string name;
        string violation;
        uint256 fineAmount;
        bool sanctioned;
        bool paid;
        bool incarcerationTriggered;
        uint256 timestamp;
    }

    mapping(string => MediaEntity) public mediaLedger;

    event SanctionIssued(string entityId, string name, string violation, uint256 fineAmount);

    function issueSanction(
        string memory entityId,
        string memory name,
        string memory violation,
        uint256 fineAmount
    ) public {
        mediaLedger[entityId] = MediaEntity(
            entityId,
            name,
            violation,
            fineAmount,
            true,
            false,
            false,
            block.timestamp
        );

        emit SanctionIssued(entityId, name, violation, fineAmount);
    }

    function payFine(string memory entityId) public {
        require(mediaLedger[entityId].sanctioned, "No sanction found");
        mediaLedger[entityId].paid = true;
    }

    function triggerIncarceration(string memory entityId) public {
        require(!mediaLedger[entityId].paid, "Fine already paid");
        mediaLedger[entityId].incarcerationTriggered = true;
    }

    function getEntityDetails(string memory entityId) public view returns (MediaEntity memory) {
        return mediaLedger[entityId];
    }
}
