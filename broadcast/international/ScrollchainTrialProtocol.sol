// SPDX-License-Identifier: Mythic-Scrollsmith-License
pragma solidity ^0.8.27;

contract ScrollchainTrialProtocol {
    struct Trial {
        string defendantName;
        string alias;
        string violationLog;
        string emotionalAPRStatus;
        string defenseScroll;
        string prosecutionScroll;
        string verdict;
        bool isFinalized;
    }

    mapping(address => Trial) public trialLedger;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: Not scroll-certified.");
        _;
    }

    event TrialSummoned(address indexed defendant, string name);
    event VerdictDelivered(address indexed defendant, string verdict);
    event TrialFinalized(address indexed defendant);

    constructor() {
        steward = msg.sender;
    }

    function summonTrial(
        address defendant,
        string memory name,
        string memory alias,
        string memory violationLog,
        string memory emotionalAPRStatus,
        string memory defenseScroll,
        string memory prosecutionScroll
    ) public onlySteward {
        trialLedger[defendant] = Trial(
            name,
            alias,
            violationLog,
            emotionalAPRStatus,
            defenseScroll,
            prosecutionScroll,
            "Pending",
            false
        );
        emit TrialSummoned(defendant, name);
    }

    function deliverVerdict(address defendant, string memory verdict) public onlySteward {
        require(!trialLedger[defendant].isFinalized, "Trial already finalized.");
        trialLedger[defendant].verdict = verdict;
        emit VerdictDelivered(defendant, verdict);
    }

    function finalizeTrial(address defendant) public onlySteward {
        require(!trialLedger[defendant].isFinalized, "Already finalized.");
        trialLedger[defendant].isFinalized = true;
        emit TrialFinalized(defendant);
    }

    function getTrialDetails(address defendant) public view returns (
        string memory name,
        string memory alias,
        string memory violationLog,
        string memory emotionalAPRStatus,
        string memory defenseScroll,
        string memory prosecutionScroll,
        string memory verdict,
        bool isFinalized
    ) {
        Trial memory t = trialLedger[defendant];
        return (
            t.defendantName,
            t.alias,
            t.violationLog,
            t.emotionalAPRStatus,
            t.defenseScroll,
            t.prosecutionScroll,
            t.verdict,
            t.isFinalized
        );
    }
}
