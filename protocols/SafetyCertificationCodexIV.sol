// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * SafetyCertificationCodexIV — Batch 1321.9.261
 * Focus: certification logs, tests, incidents, remediation
 */
contract SafetyCertificationCodexIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct TestLog {
        string lineId;
        string testName;
        string result;     // pass/fail
        string notes;
        uint256 timestamp;
    }

    struct Incident {
        string lineId;
        string summary;
        string remedy;
        uint256 timestamp;
    }

    mapping(bytes32 => TestLog[]) public tests;
    mapping(bytes32 => Incident[]) public incidents;

    event TestLogged(bytes32 indexed key, string lineId, string testName, string result);
    event IncidentLogged(bytes32 indexed key, string lineId, string summary, string remedy);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory lineId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(lineId));
    }

    function logTest(
        string calldata lineId,
        string calldata testName,
        string calldata result,
        string calldata notes
    ) external onlySteward {
        bytes32 k = keyFor(lineId);
        tests[k].push(TestLog(lineId, testName, result, notes, block.timestamp));
        emit TestLogged(k, lineId, testName, result);
    }

    function logIncident(
        string calldata lineId,
        string calldata summary,
        string calldata remedy
    ) external onlySteward {
        bytes32 k = keyFor(lineId);
        incidents[k].push(Incident(lineId, summary, remedy, block.timestamp));
        emit IncidentLogged(k, lineId, summary, remedy);
    }
}
