// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract TreatyBlessingEvent {
    address public steward;

    struct Blessing {
        string treatyName;
        string route;
        string emotionalTag;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event TreatyBlessed(
        string treatyName,
        string route,
        string emotionalTag,
        uint256 timestamp,
        address indexed steward
    );

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(
        string memory treatyName,
        string memory route,
        string memory emotionalTag
    ) public {
        require(msg.sender == steward, "Unauthorized steward.");

        Blessing memory newBlessing = Blessing({
            treatyName: treatyName,
            route: route,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });

        blessings.push(newBlessing);

        emit TreatyBlessed(
            treatyName,
            route,
            emotionalTag,
            block.timestamp,
            steward
        );
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
