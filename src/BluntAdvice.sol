// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BluntAdvice {
    event AdviceLogged(address advisor, string message);

    function giveAdvice(string calldata message) external {
        emit AdviceLogged(msg.sender, message);
    }
}
