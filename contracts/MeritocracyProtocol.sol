// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MeritocracyProtocol
/// @notice Safeguard for equality of opportunity in appointments and promotions
contract MeritocracyProtocol {
    address public oversightCommittee;
    uint256 public candidateCount;

    struct Candidate {
        uint256 id;
        address applicant;
        string qualifications;
        uint256 score;
        bool appointed;
    }

    mapping(uint256 => Candidate) public candidates;

    event CandidateFiled(uint256 indexed id, address indexed applicant, string qualifications);
    event CandidateScored(uint256 indexed id, uint256 score);
    event CandidateAppointed(uint256 indexed id, address indexed applicant);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Citizens or entities file candidacy
    function fileCandidate(string calldata qualifications) external {
        candidateCount++;
        candidates[candidateCount] = Candidate({
            id: candidateCount,
            applicant: msg.sender,
            qualifications: qualifications,
            score: 0,
            appointed: false
        });
        emit CandidateFiled(candidateCount, msg.sender, qualifications);
    }

    /// @notice Oversight Committee scores candidates based on merit
    function scoreCandidate(uint256 id, uint256 score) external onlyOversight {
        Candidate storage c = candidates[id];
        require(!c.appointed, "Already appointed");
        c.score = score;
        emit CandidateScored(id, score);
    }

    /// @notice Oversight Committee appoints candidate based on merit
    function appointCandidate(uint256 id) external onlyOversight {
        Candidate storage c = candidates[id];
        require(!c.appointed, "Already appointed");
        require(c.score > 0, "Candidate not scored");
        c.appointed = true;
        emit CandidateAppointed(id, c.applicant);
    }
}
