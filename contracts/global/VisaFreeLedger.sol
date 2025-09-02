// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VisaFreeLedger {
    struct WorkerLog {
        string stewardName;
        string destinationCountry;
        string employer;
        uint256 timestamp;
        uint8 emotionalAPR; // 1–10 scale
        bool directRecruitment;
    }

    WorkerLog[] public logs;

    event WorkerLogged(
        string stewardName,
        string destinationCountry,
        string employer,
        uint256 timestamp,
        uint8 emotionalAPR,
        bool directRecruitment
    );

    function logWorker(
        string memory _stewardName,
        string memory _destinationCountry,
        string memory _employer,
        uint8 _emotionalAPR,
        bool _directRecruitment
    ) public {
        logs.push(WorkerLog(
            _stewardName,
            _destinationCountry,
            _employer,
            block.timestamp,
            _emotionalAPR,
            _directRecruitment
        ));
        emit WorkerLogged(_stewardName, _destinationCountry, _employer, block.timestamp, _emotionalAPR, _directRecruitment);
    }

    function getWorker(uint256 index) public view returns (WorkerLog memory) {
        require(index < logs.length, "Invalid index");
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
