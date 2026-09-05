// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommandFeedback {
    event CommandIssued(address commander, string order);
    event FeedbackReceived(address troop, string feedback);

    function issueCommand(string calldata order) external {
        emit CommandIssued(msg.sender, order);
    }

    function giveFeedback(string calldata feedback) external {
        emit FeedbackReceived(msg.sender, feedback);
    }
}
