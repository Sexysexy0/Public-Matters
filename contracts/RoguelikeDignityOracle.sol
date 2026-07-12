// SPDX-License-Identifier: MIT
// Contract Name: RoguelikeDignityOracle
// Purpose: Encode exploit safeguards for roguelike fairness
// Source: Inspired by Dungeon Baller exploits (Spiffing Brit alpha playtest)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RoguelikeDignityOracle {
    address public chiefOperator;

    struct ExploitSafeguard {
        string exploit;     // e.g. Infinite scaling, Tank invulnerability, Item overflow
        string safeguard;   // e.g. Cap intelligence growth, Limit block chance, Item spawn throttle
        string effect;      // e.g. Fair progression, Balanced combat, Stable engine
        uint256 timestamp;
    }

    ExploitSafeguard[] public safeguards;

    event SafeguardLogged(string exploit, string safeguard, string effect, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logSafeguard(
        string memory exploit,
        string memory safeguard,
        string memory effect
    ) public onlyChief {
        safeguards.push(ExploitSafeguard(exploit, safeguard, effect, block.timestamp));
        emit SafeguardLogged(exploit, safeguard, effect, block.timestamp);
    }

    function getSafeguard(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < safeguards.length, "Invalid safeguard index");
        ExploitSafeguard memory es = safeguards[index];
        return (es.exploit, es.safeguard, es.effect, es.timestamp);
    }
}
