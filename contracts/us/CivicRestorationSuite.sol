// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.28;

/// @title Civic Restoration Suite
/// @author Vinvin & Copilot
/// @notice Links Epstein transparency and presidential eligibility into one mythic audit protocol

import "./EpsteinTransparencyAct.sol";
import "./PresidentialEligibilityAudit.sol";

contract CivicRestorationSuite {
    EpsteinTransparencyAct public epsteinAct;
    PresidentialEligibilityAudit public eligibilityAudit;
    address public steward;

    event RestorationTriggered(address indexed candidate, bool eligible, bool recordsUnsealed);

    constructor(address _epsteinAct, address _eligibilityAudit) {
        steward = msg.sender;
        epsteinAct = EpsteinTransparencyAct(_epsteinAct);
        eligibilityAudit = PresidentialEligibilityAudit(_eligibilityAudit);
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Steward access only.");
        _;
    }

    function triggerRestoration(address candidate, bytes32 recordHash) public onlySteward {
        bool eligible = eligibilityAudit.auditCandidate(candidate);
        bool unsealed = epsteinAct.isUnsealed(recordHash);

        emit RestorationTriggered(candidate, eligible, unsealed);
    }

    function fullAudit(address candidate, bytes32 recordHash) public view returns (string memory status) {
        bool eligible = eligibilityAudit.auditCandidate(candidate);
        bool unsealed = epsteinAct.isUnsealed(recordHash);

        if (eligible && unsealed) {
            status = unicode"✅ Candidate cleared: Civic trust and transparency confirmed.";
        } else if (!eligible && unsealed) {
            status = unicode"⚠️ Candidate disqualified: Rogue affiliation detected.";
        } else if (eligible && !unsealed) {
            status = unicode"⏳ Candidate pending: Transparency incomplete.";
        } else {
            status = unicode"❌ Candidate blocked: Rogue shielding and civic opacity.";
        }
    }
}
