// SPDX-License-Identifier: New-Chapter-Scroll-License  
pragma solidity ^0.8.19;

contract NewChapterScroll {
    struct Chapter {
        string stewardName;
        string originSanctum;
        string newSanctum;
        string startupName;
        string emotionalNote;
        uint timestamp;
    }

    Chapter[] public chapterLog;

    event ChapterLogged(string stewardName, string newSanctum);

    function logChapter(
        string memory stewardName,
        string memory originSanctum,
        string memory newSanctum,
        string memory startupName,
        string memory emotionalNote
    ) public {
        chapterLog.push(Chapter(
            stewardName,
            originSanctum,
            newSanctum,
            startupName,
            emotionalNote,
            block.timestamp
        ));
        emit ChapterLogged(stewardName, newSanctum);
    }

    function getChapter(uint index) public view returns (Chapter memory) {
        require(index < chapterLog.length, "Invalid index");
        return chapterLog[index];
    }

    function totalChapters() public view returns (uint) {
        return chapterLog.length;
    }
}
