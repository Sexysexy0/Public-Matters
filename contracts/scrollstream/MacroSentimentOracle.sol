// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MacroSentimentOracle {
    int256 public cpi;
    int256 public jobsReport;
    string public fedTone;

    event SentimentUpdated(int256 cpi, int256 jobs, string fedTone);

    function updateSentiment(int256 _cpi, int256 _jobs, string memory _fedTone) public {
        cpi = _cpi;
        jobsReport = _jobs;
        fedTone = _fedTone;
        emit SentimentUpdated(_cpi, _jobs, _fedTone);
    }
}
