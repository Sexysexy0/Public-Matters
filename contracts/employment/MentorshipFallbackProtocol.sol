// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract MentorshipFallbackProtocol {
    address public steward;

    struct Mentee {
        string name;
        bool isUnderReview;
        bool isInMentorship;
        uint256 progressScore;
        uint256 rerouteTimestamp;
    }

    mapping(address => Mentee) public mentees;
    event MenteeRerouted(string name, string reason);
    event ProgressUpdated(string name, uint256 score, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized mentorship ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function rerouteToMentorship(address menteeAddr, string memory name) public onlySteward {
        mentees[menteeAddr] = Mentee({
            name: name,
            isUnderReview: true,
            isInMentorship: true,
            progressScore: 0,
            rerouteTimestamp: block.timestamp
        });

        emit MenteeRerouted(name, "Performance below threshold. Rerouted to mentorship sanctum.");
    }

    function updateProgress(address menteeAddr, uint256 score) public onlySteward {
        mentees[menteeAddr].progressScore = score;

        string memory status;
        if (score >= 75) {
            mentees[menteeAddr].isUnderReview = false;
            mentees[menteeAddr].isInMentorship = false;
            status = "Restored. Ready for regularization.";
        } else if (score >= 50) {
            status = "Improving. Continue mentorship.";
        } else {
            status = "Needs deeper guidance. Emotional APR sync required.";
        }

        emit ProgressUpdated(mentees[menteeAddr].name, score, status);
    }

    function auditMentee(address menteeAddr) public view returns (string memory) {
        Mentee memory m = mentees[menteeAddr];
        return string(abi.encodePacked(
            "Mentee: ", m.name,
            " | Under Review: ", m.isUnderReview ? "Yes" : "No",
            " | In Mentorship: ", m.isInMentorship ? "Yes" : "No",
            " | Progress Score: ", uint2str(m.progressScore)
        ));
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
