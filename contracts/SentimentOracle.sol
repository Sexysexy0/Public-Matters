// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SentimentOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event SentimentAlert(string source, string sentiment);

    function logSentiment(string memory _source, string memory _sentiment) external {
        emit SentimentAlert(_source, _sentiment);
        // ORACLE: Negative sentiment flagged for governance.
    }
}
