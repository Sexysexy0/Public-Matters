// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCongressionalSummonProtocol {
    address public steward;
    mapping(string => bool) public summoned;

    event SummonActivated(string lawmaker, string reason, bool isSummoned, uint timestamp);

    function activateSummon(string memory lawmaker, string memory reason) public {
        summoned[lawmaker] = true;
        emit SummonActivated(lawmaker, reason, true, block.timestamp);
    }

    function checkSummonStatus(string memory lawmaker) public view returns (bool) {
        return summoned[lawmaker];
    }
}
