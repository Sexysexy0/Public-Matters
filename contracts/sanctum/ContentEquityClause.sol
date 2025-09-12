// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContentEquityClause {
    enum ContentType { Legacy, Collaborative, Exclusive }
    enum RightsStatus { Reserved, Shared, Licensed }

    struct ContentRecord {
        uint256 id;
        string title;
        address creator;
        ContentType contentType;
        RightsStatus rightsStatus;
        string equityClause;
        uint256 timestamp;
    }

    mapping(uint256 => ContentRecord) public contentRegistry;
    uint256 public contentCount;

    event ContentLogged(uint256 id, string title, ContentType contentType, RightsStatus rightsStatus);

    function logContent(
        string memory title,
        address creator,
        ContentType contentType,
        RightsStatus rightsStatus,
        string memory equityClause,
        uint256 timestamp
    ) public {
        contentRegistry[contentCount] = ContentRecord(
            contentCount,
            title,
            creator,
            contentType,
            rightsStatus,
            equityClause,
            timestamp
        );
        emit ContentLogged(contentCount, title, contentType, rightsStatus);
        contentCount++;
    }

    function getContent(uint256 id) public view returns (ContentRecord memory) {
        return contentRegistry[id];
    }
}
