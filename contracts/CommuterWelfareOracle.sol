// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CommuterWelfareOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    // [PARA NETWORK LOGIC] Monitoring the impact on daily commuters
    function checkWaitTime(uint256 _minutes) public pure returns (string memory) {
        if (_minutes > 30) {
            return "ALERT: System Latency. Commuter productivity at risk. Deploy more nodes.";
        }
        return "STATUS: Acceptable Transit Flow.";
    }
}
