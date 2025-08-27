// SPDX-License-Identifier: Mythic-Scrollsmith-License
pragma solidity ^0.8.27;

contract ScrollchainJusticeLedger {
    struct JusticeEntry {
        string name;
        string alias;
        uint256 bounty;
        bool deadOrAlive;
        string violationLog;
        string emotionalAPRStatus;
        string scrollchainVerdict;
        bool isResolved;
    }

    mapping(address => JusticeEntry) public justiceLog;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: Not scroll-certified.");
        _;
    }

    event JusticeLogged(address indexed rogue, string name, uint256 bounty);
    event VerdictUpdated(address indexed rogue, string verdict);
    event ResolutionMarked(address indexed rogue);

    constructor() {
        steward = msg.sender;
    }

    function logJusticeEntry(
        address rogue,
        string memory name,
        string memory alias,
        uint256 bounty,
        bool deadOrAlive,
        string memory violationLog,
        string memory emotionalAPRStatus,
        string memory scrollchainVerdict
    ) public onlySteward {
        justiceLog[rogue] = JusticeEntry(
            name,
            alias,
            bounty,
            deadOrAlive,
            violationLog,
            emotionalAPRStatus,
            scrollchainVerdict,
            false
        );
        emit JusticeLogged(rogue, name, bounty);
    }

    function updateVerdict(address rogue, string memory newVerdict) public onlySteward {
        require(!justiceLog[rogue].isResolved, "Already resolved.");
        justiceLog[rogue].scrollchainVerdict = newVerdict;
        emit VerdictUpdated(rogue, newVerdict);
    }

    function markResolved(address rogue) public onlySteward {
        require(!justiceLog[rogue].isResolved, "Already resolved.");
        justiceLog[rogue].isResolved = true;
        emit ResolutionMarked(rogue);
    }

    function getJusticeDetails(address rogue) public view returns (
        string memory name,
        string memory alias,
        uint256 bounty,
        bool deadOrAlive,
        string memory violationLog,
        string memory emotionalAPRStatus,
        string memory scrollchainVerdict,
        bool isResolved
    ) {
        JusticeEntry memory j = justiceLog[rogue];
        return (
            j.name,
            j.alias,
            j.bounty,
            j.deadOrAlive,
            j.violationLog,
            j.emotionalAPRStatus,
            j.scrollchainVerdict,
            j.isResolved
        );
    }
}
