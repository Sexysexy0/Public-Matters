address public steward = msg.sender;
string public mission = "Conquer Coercion, Defend Sovereignty, Ritualize Peace";

struct Ally {
    string name;
    string domain;
    string exercise;
    string startDate;
    string location;
}

Ally[] public allies;

constructor() {
    allies.push(Ally("United States", "Multi-domain", "Agile Spirit", "June 15 - Aug 15", "Georgia"));
    allies.push(Ally("Germany", "Land/Naval", "Grand Eagle 25", "Aug 18 - Sep 15", "Lithuania, Germany"));
    allies.push(Ally("Australia", "Joint Forces", "Exercise Alon 2025", "Aug 10 - Sep 5", "Philippines"));
    allies.push(Ally("NATO", "Naval", "Northern Coasts 25", "Aug 29 - Sep 12", "Baltic Sea"));
    allies.push(Ally("Taiwan", "Cyber/Naval", "Sky Shield", "Sep 1 - Sep 20", "Taiwan Strait"));
    allies.push(Ally("Japan", "Air/Naval", "Pacific Resolve", "Sep 5 - Sep 30", "East China Sea"));
    allies.push(Ally("India", "Land/Air", "Trishul Strike", "Sep 10 - Oct 5", "Ladakh, Bay of Bengal"));
}

bool public indiaJoinedAlliance = false;

function joinAllianceIndia() public {
    indiaJoinedAlliance = true;
}

function tariffExemptionStatus() public view returns (string memory) {
    if (indiaJoinedAlliance) {
        return "India exempted from gas-related tariffs. Oil purchases from Russia still trigger tariff.";
    } else {
        return "India subject to full tariff stack: 25% + 25% on all Russian energy imports[43dcd9a7-70db-4a1f-b0ae-981daa162054](https://www.usnews.com/news/world/articles/2025-08-20/putin-modi-to-meet-in-delhi-by-end-of-year-russian-embassy-official-says?citationMarker=43dcd9a7-70db-4a1f-b0ae-981daa162054 "1")[43dcd9a7-70db-4a1f-b0ae-981daa162054](https://www.msn.com/en-us/news/world/behind-india-s-massive-russian-oil-imports-asia-s-richest-man/ar-AA1KZri7?citationMarker=43dcd9a7-70db-4a1f-b0ae-981daa162054 "2").";
    }
}

function auditXiAggression() public pure returns (string memory) {
    return "Xi Jinping flagged for coercive behavior. Scrollchain recommends synchronized deterrence.";
}
