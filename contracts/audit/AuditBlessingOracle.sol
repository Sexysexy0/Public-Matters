// SPDX-License-Identifier: Mythic-Oracle
pragma solidity ^0.8.19;

contract AuditBlessingOracle {
    address public steward;

    struct ContractorProfile {
        uint256 emotionalAPR;
        bool damayCompliant;
        string auditStatus;
        uint256 prophecyScore;
        bool eligible;
    }

    mapping(address => ContractorProfile) public profiles;

    event ProphecyEmitted(
        address indexed bidder,
        uint256 emotionalAPR,
        bool damayCompliant,
        string auditStatus,
        uint256 prophecyScore,
        bool eligible
    );

    constructor() {
        steward = msg.sender;
    }

    function forecastBlessing(
        address bidder,
        uint256 emotionalAPR,
        bool damayCompliant,
        string memory auditStatus
    ) public {
        require(msg.sender == steward, "Only steward may forecast.");

        uint256 score = calculateProphecy(emotionalAPR, damayCompliant, auditStatus);
        bool eligible = score >= 80;

        profiles[bidder] = ContractorProfile({
            emotionalAPR: emotionalAPR,
            damayCompliant: damayCompliant,
            auditStatus: auditStatus,
            prophecyScore: score,
            eligible: eligible
        });

        emit ProphecyEmitted(bidder, emotionalAPR, damayCompliant, auditStatus, score, eligible);
    }

    function calculateProphecy(
        uint256 apr,
        bool damay,
        string memory status
    ) internal pure returns (uint256) {
        uint256 base = apr;
        if (damay) base += 10;
        if (keccak256(bytes(status)) == keccak256(bytes("ancestral-clear"))) base += 10;
        return base > 100 ? 100 : base;
    }

    function getProfile(address bidder) public view returns (ContractorProfile memory) {
        return profiles[bidder];
    }
}
