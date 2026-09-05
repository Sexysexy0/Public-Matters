// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiplomaticNuance {
    struct Ally {
        address allyAddress;
        string interests;
    }

    mapping(address => Ally) public allies;

    event AllyRegistered(address ally, string interests);

    function registerAlly(address ally, string calldata interests) external {
        allies[ally] = Ally(ally, interests);
        emit AllyRegistered(ally, interests);
    }
}
