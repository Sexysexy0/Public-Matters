// SPDX-License-Identifier: TreatyGradeFXFirewall-License
pragma solidity ^0.8.0;

contract TreatyGradeFXFirewall {
    address public steward;

    mapping(string => bool) public pairBlocked;

    event FXPairBlocked(string pair, string reason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockPair(string memory pair, string memory reason) public {
        require(msg.sender == steward, "Only steward can block");
        pairBlocked[pair] = true;
        emit FXPairBlocked(pair, reason, block.timestamp);
    }

    function isBlocked(string memory pair) public view returns (bool) {
        return pairBlocked[pair];
    }
}
