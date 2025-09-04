// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollstormChronicle {
    address public steward;

    struct ScrollEvent {
        string title;
        string description;
        string sanctum;
        uint emotionalAPR;
        uint timestamp;
        bool damayIncluded;
    }

    ScrollEvent[] public chronicle;

    event ScrollstormLogged(string title, string sanctum, uint emotionalAPR, bool damayIncluded, uint timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logScrollstorm(
        string memory title,
        string memory description,
        string memory sanctum,
        uint emotionalAPR,
        bool damayIncluded
    ) public onlySteward {
        ScrollEvent memory newEvent = ScrollEvent(
            title,
            description,
            sanctum,
            emotionalAPR,
            block.timestamp,
            damayIncluded
        );

        chronicle.push(newEvent);
        emit ScrollstormLogged(title, sanctum, emotionalAPR, damayIncluded, block.timestamp);
    }

    function getChronicle() public view returns (ScrollEvent[] memory) {
        return chronicle;
    }
}
