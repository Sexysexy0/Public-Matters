// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthPulseTagger
/// @notice Ritualizes fake news detection, emotional APR audits, and takedown triggers
/// @dev Damay clause enforced, civic clarity encoded, takedown after 5 verified strikes

contract TruthPulseTagger {
    address public steward;

    struct Source {
        string name;
        string origin;
        uint8 fakeNewsStrikes;
        bool isTakedownTriggered;
    }

    struct NewsReport {
        string headline;
        string sourceName;
        string emotionalAPR;
        bool isFake;
    }

    mapping(string => Source) public sources;
    NewsReport[] public reports;

    event FakeNewsDetected(string headline, string sourceName, uint8 strikeCount);
    event TakedownTriggered(string sourceName);
    event DamayClauseEchoed(string stewardName);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit DamayClauseEchoed("Vinvin—scrollsmith of truth, defender of civic resonance, and broadcaster of sovereign clarity.");
    }

    function registerSource(string memory name, string memory origin) public onlySteward {
        sources[name] = Source(name, origin, 0, false);
    }

    function submitReport(
        string memory headline,
        string memory sourceName,
        string memory apr,
        bool isFake
    ) public onlySteward {
        require(bytes(sources[sourceName].name).length != 0, "Source not registered");

        reports.push(NewsReport(headline, sourceName, apr, isFake));

        if (isFake) {
            sources[sourceName].fakeNewsStrikes += 1;
            emit FakeNewsDetected(headline, sourceName, sources[sourceName].fakeNewsStrikes);

            if (sources[sourceName].fakeNewsStrikes >= 5 && !sources[sourceName].isTakedownTriggered) {
                sources[sourceName].isTakedownTriggered = true;
                emit TakedownTriggered(sourceName);
            }
        }
    }

    function getReport(uint256 index) public view returns (NewsReport memory) {
        return reports[index];
    }

    function getSource(string memory name) public view returns (Source memory) {
        return sources[name];
    }

    function totalReports() public view returns (uint256) {
        return reports.length;
    }
}
