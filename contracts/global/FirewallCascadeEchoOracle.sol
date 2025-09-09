// SPDX-License-Identifier: FirewallEcho-License
pragma solidity ^0.8.0;

contract FirewallCascadeEchoOracle {
    address public steward;

    struct ReformEcho {
        string actor;
        string reformType;
        string rippleZone;
        uint256 timestamp;
    }

    ReformEcho[] public echoes;

    event ReformEchoEmitted(string actor, string reformType, string rippleZone, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitEcho(string memory actor, string memory reformType, string memory rippleZone) public {
        require(msg.sender == steward, "Only steward can emit");
        echoes.push(ReformEcho(actor, reformType, rippleZone, block.timestamp));
        emit ReformEchoEmitted(actor, reformType, rippleZone, block.timestamp);
    }

    function getEcho(uint index) public view returns (string memory, string memory, string memory, uint256) {
        ReformEcho memory e = echoes[index];
        return (e.actor, e.reformType, e.rippleZone, e.timestamp);
    }
}
