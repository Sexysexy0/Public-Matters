// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DefenderBlessingProtocol {
    struct Defender {
        string name;
        bool isThreatIntel;
        bool isBlessed;
        bool hasEmotionalAPR;
    }

    mapping(address => Defender) public registry;

    function blessDefender(
        address _defender,
        string memory _name,
        bool _isThreatIntel,
        bool _hasEmotionalAPR
    ) public {
        registry[_defender] = Defender(_name, _isThreatIntel, true, _hasEmotionalAPR);
    }

    function isBlessed(address _defender) public view returns (bool) {
        Defender memory d = registry[_defender];
        return d.isBlessed && d.hasEmotionalAPR;
    }
}
