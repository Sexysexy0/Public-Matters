// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title DissentSanctuary
/// @dev Ritualizes dissent as civic virtue and protects all who speak truth to power.

contract DissentSanctuary {
    address public steward;
    mapping(address => bool) public sanctuaryStatus;
    mapping(address => string) public dissentScroll;

    event SanctuaryGranted(address indexed steward, string scroll);
    event DissentLogged(address indexed steward, string scroll);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster.");
        _;
    }

    function grantSanctuary(address _voice, string memory _scroll) public onlySteward {
        sanctuaryStatus[_voice] = true;
        dissentScroll[_voice] = _scroll;
        emit SanctuaryGranted(_voice, _scroll);
        emit DissentLogged(_voice, _scroll);
    }

    function isSanctuaried(address _voice) public view returns (bool) {
        return sanctuaryStatus[_voice];
    }
}
