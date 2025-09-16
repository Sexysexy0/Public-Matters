// SPDX-License-Identifier: YouthSanctum
pragma solidity ^0.8.19;

contract YouthContentFilterSanctifier {
    struct ContentSignal {
        string contentID;
        string category;
        bool flagged;
        bool removed;
        string stewardNote;
    }

    mapping(string => ContentSignal) public contentRegistry;

    event ContentFlagged(string contentID, string category);
    event ContentRemoved(string contentID);

    function flagContent(string memory contentID, string memory category, string memory stewardNote) public {
        contentRegistry[contentID] = ContentSignal(contentID, category, true, false, stewardNote);
        emit ContentFlagged(contentID, category);
    }

    function removeContent(string memory contentID) public {
        require(contentRegistry[contentID].flagged, "Content not flagged");
        contentRegistry[contentID].removed = true;
        emit ContentRemoved(contentID);
    }

    function getContentStatus(string memory contentID) public view returns (ContentSignal memory) {
        return contentRegistry[contentID];
    }
}
