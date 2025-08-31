// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FloodControlAudit {
    event FloodEventLogged(string region, uint256 year, string cause, uint256 traumaIndex);
    event InfraProposalAudited(string projectName, string region, bool approved, string reason);
    event OverrideTriggered(string region, string reason);

    struct Proposal {
        string projectName;
        string region;
        uint256 emotionalAPR;
        bool ancestralBlessing;
        bool barangayConsent;
    }

    uint256 public traumaThreshold = 65;
    Proposal[] public proposals;

    function logFloodEvent(string memory region, uint256 year, string memory cause, uint256 traumaIndex) public {
        emit FloodEventLogged(region, year, cause, traumaIndex);
        if (traumaIndex >= traumaThreshold) {
            emit OverrideTriggered(region, "Historical trauma threshold breached");
        }
    }

    function auditProposal(
        string memory projectName,
        string memory region,
        uint256 emotionalAPR,
        bool ancestralBlessing,
        bool barangayConsent
    ) public {
        bool approved = emotionalAPR >= 70 && ancestralBlessing && barangayConsent;
        string memory reason = approved ? "Approved with full ritual alignment" : "Rejected: ritual misalignment or low APR";
        proposals.push(Proposal(projectName, region, emotionalAPR, ancestralBlessing, barangayConsent));
        emit InfraProposalAudited(projectName, region, approved, reason);
        if (!approved) {
            emit OverrideTriggered(region, reason);
        }
    }

    function updateTraumaThreshold(uint256 newThreshold) public {
        traumaThreshold = newThreshold;
    }

    function getProposal(uint256 index) public view returns (Proposal memory) {
        return proposals[index];
    }
}
