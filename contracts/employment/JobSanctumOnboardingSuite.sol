// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract JobSanctumOnboardingSuite {
    address public steward;

    struct Applicant {
        string name;
        string educationLevel;
        bool isPresent;
        bool isRegularized;
        uint256 onboardingTimestamp;
        uint256 evaluationScore;
    }

    mapping(address => Applicant) public applicants;
    event ApplicantAccepted(string name, string status);
    event EvaluationUpdated(string name, uint256 score, string result);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized hiring ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function acceptApplicant(address applicantAddr, string memory name, string memory educationLevel) public onlySteward {
        applicants[applicantAddr] = Applicant({
            name: name,
            educationLevel: educationLevel,
            isPresent: true,
            isRegularized: false,
            onboardingTimestamp: block.timestamp,
            evaluationScore: 0
        });

        emit ApplicantAccepted(name, "Accepted based on base education and presence. Damay clause honored.");
    }

    function updateEvaluation(address applicantAddr, uint256 score) public onlySteward {
        applicants[applicantAddr].evaluationScore = score;

        string memory result;
        if (score >= 75) {
            applicants[applicantAddr].isRegularized = true;
            result = "Regularized. Performance acceptable.";
        } else if (score >= 50) {
            result = "Performance needs improvement. Position rerouted.";
        } else {
            result = "Not regularized. Mentorship required. Damay clause fallback active.";
        }

        emit EvaluationUpdated(applicants[applicantAddr].name, score, result);
    }

    function auditApplicant(address applicantAddr) public view returns (string memory) {
        Applicant memory a = applicants[applicantAddr];
        if (a.isPresent) {
            return string(abi.encodePacked(
                "Applicant: ", a.name,
                " | Education: ", a.educationLevel,
                " | Evaluation: ", uint2str(a.evaluationScore),
                " | Regularized: ", a.isRegularized ? "Yes" : "No"
            ));
        } else {
            return "Applicant not present. Emotional resonance missing.";
        }
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
