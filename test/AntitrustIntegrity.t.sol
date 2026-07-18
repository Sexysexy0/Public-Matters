// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AntitrustIntegrity {
    address[] public guardians;
    uint256 public bountyAmount;

    struct Case {
        uint id;
        bytes32[] evidenceHashes;   // audit trail of all evidences
        bool paid;
        uint votes;
        bool accepted;
        address whistleblower;
    }

    mapping(uint => Case) public cases;
    uint public totalCases;

    event WhistleFiled(uint indexed id, bytes32 evidenceHash, address whistleblower);
    event EvidenceAdded(uint indexed id, bytes32 evidenceHash);
    event GuardianVote(uint indexed caseId, address guardian);
    event CaseAccepted(uint indexed caseId);
    event BountyReleased(uint indexed caseId, address whistleblower, uint amount);

    constructor(address[] memory _guardians, uint256 _bountyAmount) {
        guardians = _guardians;
        bountyAmount = _bountyAmount;
    }

    // File a new whistle case
    function fileWhistle(bytes32 _evidenceHash) public payable returns (uint) {
        totalCases++;
        Case storage c = cases[totalCases];
        c.id = totalCases;
        c.evidenceHashes.push(_evidenceHash);
        c.paid = msg.value >= bountyAmount;
        c.votes = 0;
        c.accepted = false;
        c.whistleblower = msg.sender;

        emit WhistleFiled(totalCases, _evidenceHash, msg.sender);
        return totalCases;
    }

    // Add more evidence to an existing case (audit trail)
    function addEvidence(uint caseId, bytes32 _evidenceHash) public {
        require(msg.sender == cases[caseId].whistleblower, "Only whistleblower can add");
        cases[caseId].evidenceHashes.push(_evidenceHash);
        emit EvidenceAdded(caseId, _evidenceHash);
    }

    // Guardian voting
    function voteOnCase(uint caseId) public {
        require(isGuardian(msg.sender), "Not a guardian");
        require(!cases[caseId].accepted, "Already accepted");

        cases[caseId].votes++;
        emit GuardianVote(caseId, msg.sender);

        if (cases[caseId].votes > guardians.length / 2) {
            cases[caseId].accepted = true;
            emit CaseAccepted(caseId);

            // ✅ Release bounty if paid
            if (cases[caseId].paid) {
                (bool sent, ) = payable(cases[caseId].whistleblower).call{value: bountyAmount}("");
                require(sent, "Bounty transfer failed");
                emit BountyReleased(caseId, cases[caseId].whistleblower, bountyAmount);
            }
        }
    }

    function isGuardian(address addr) internal view returns (bool) {
        for (uint i = 0; i < guardians.length; i++) {
            if (guardians[i] == addr) return true;
        }
        return false;
    }

    // Getters
    function getEvidence(uint caseId) public view returns (bytes32[] memory) {
        return cases[caseId].evidenceHashes;
    }

    function isAccepted(uint caseId) public view returns (bool) {
        return cases[caseId].accepted;
    }
}
