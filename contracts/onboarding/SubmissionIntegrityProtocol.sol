// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SubmissionIntegrityProtocol {
    struct Submission {
        string docHash;
        string submitter;
        string method; // e.g. "PC", "Mobile", "BarangayNet"
        bool isOnchain;
        string emotionalTag;
        uint256 timestamp;
    }

    Submission[] public submissions;

    event SubmissionLogged(string docHash, string submitter, string method, bool isOnchain, string emotionalTag);

    function logSubmission(
        string memory _docHash,
        string memory _submitter,
        string memory _method,
        bool _isOnchain,
        string memory _emotionalTag
    ) public {
        submissions.push(Submission(_docHash, _submitter, _method, _isOnchain, _emotionalTag, block.timestamp));
        emit SubmissionLogged(_docHash, _submitter, _method, _isOnchain, _emotionalTag);
    }

    function totalSubmissions() public view returns (uint256) {
        return submissions.length;
    }
}
