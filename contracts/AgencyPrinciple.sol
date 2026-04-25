// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AgencyPrinciple {
    struct Action {
        address actor;
        string intent;
        uint256 timestamp;
    }

    event ActionLogged(address actor, string intent);

    function performAction(string memory _intent) external {
        emit ActionLogged(msg.sender, _intent);
        // RULE: No arbitrary restriction – agency preserved.
    }
}
