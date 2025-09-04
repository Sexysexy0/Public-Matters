// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EmotionalAPR.sol";

contract KinderQueenBlessing {
    address public steward;
    struct KinderQueen {
        string name;
        uint emotionalAPR;
        bool blessed;
        uint timestamp;
    }

    mapping(string => KinderQueen) public registry;

    event QueenBlessed(string name, uint emotionalAPR, uint timestamp);
    event BlessingVerified(string name, bool blessed);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessQueen(string memory name, string memory emotionalSignal) public onlySteward {
        uint apr = EmotionalAPR.calculate(emotionalSignal);
        bool blessed = apr >= 90;

        registry[name] = KinderQueen(
            name,
            apr,
            blessed,
            block.timestamp
        );

        emit QueenBlessed(name, apr, block.timestamp);
    }

    function verifyBlessing(string memory name) public view returns (bool) {
        bool blessed = registry[name].blessed;
        emit BlessingVerified(name, blessed);
        return blessed;
    }
}
