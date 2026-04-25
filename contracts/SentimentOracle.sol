// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SentimentOracle {
    event SentimentAlert(string source, string sentiment);

    function logSentiment(string memory _source, string memory _sentiment) external {
        emit SentimentAlert(_source, _sentiment);
        // ORACLE: Negative sentiment flagged for governance.
    }
}
