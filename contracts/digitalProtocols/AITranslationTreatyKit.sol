// AITranslationTreatyKit.sol
// Treaty-grade protocol for auto-translating global broadcasts into English subtitles

pragma solidity ^0.8.19;

contract AITranslationTreatyKit {
    struct Broadcast {
        string sourceLanguage;
        string videoURL;
        string translatedText;
        bool subtitleGenerated;
        bool civicRelevanceTagged;
    }

    Broadcast[] public feeds;

    function submitBroadcast(string memory lang, string memory url) public {
        feeds.push(Broadcast(lang, url, "", false, false));
    }

    function generateSubtitle(uint256 id, string memory translation) public {
        Broadcast storage b = feeds[id];
        b.translatedText = translation;
        b.subtitleGenerated = true;
    }

    function tagCivicRelevance(uint256 id) public {
        Broadcast storage b = feeds[id];
        require(b.subtitleGenerated, "Subtitle not yet generated");
        b.civicRelevanceTagged = true;
    }

    function getFeed(uint256 id) public view returns (Broadcast memory) {
        return feeds[id];
    }
}
