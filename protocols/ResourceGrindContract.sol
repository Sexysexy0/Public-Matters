// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResourceGrindContract {
    address public employer;
    uint256 public rewardGold;

    // [Goal: Outsource the "tedious farming" to other players/NPCs]
    function postGrindJob() external payable {
        employer = msg.sender;
        rewardGold = msg.value;
    }

    function completeJob(bool _delivered) external {
        require(_delivered, "Items not yet received.");
        payable(msg.sender).transfer(rewardGold);
    }
}
