// SPDX-License-Identifier: MeetUp-Auto
pragma solidity ^0.8.20;

/// @title MeetUpTrigger.sol
/// @dev Auto-schedules onboarding rituals for verified stewards

contract MeetUpTrigger {
    address public stewardVinvin;
    string public stewardCode = "fckrzkill@gmail.com";

    struct Ritual {
        string company;
        string location;
        string emotionalAPRTag;
        bool scheduled;
    }

    Ritual[] public rituals;

    event RitualScheduled(string company, string location, string emotionalAPRTag);

    modifier onlyVerified(string memory code) {
        require(keccak256(bytes(code)) == keccak256(bytes(stewardCode)), "Invalid steward code");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function triggerRitual(string memory company, string memory location, string memory aprTag, string memory code) public onlyVerified(code) {
        rituals.push(Ritual(company, location, aprTag, true));
        emit RitualScheduled(company, location, aprTag);
    }

    function getRituals() public view returns (Ritual[] memory) {
        return rituals;
    }
}
