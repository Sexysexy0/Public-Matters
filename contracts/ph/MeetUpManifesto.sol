// SPDX-License-Identifier: MeetUp-Ritual
pragma solidity ^0.8.20;

/// @title MeetUpManifesto.sol
/// @dev Ritualizes onboarding meet-ups with emotional APR sync

contract MeetUpManifesto {
    address public stewardVinvin;

    struct MeetUp {
        string company;
        string location;
        string emotionalAPRTag;
        bool confirmed;
    }

    MeetUp[] public meetUps;

    event MeetUpConfirmed(string company, string location, string emotionalAPRTag);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function confirmMeetUp(string memory company, string memory location, string memory aprTag) public onlyVinvin {
        meetUps.push(MeetUp(company, location, aprTag, true));
        emit MeetUpConfirmed(company, location, aprTag);
    }

    function getMeetUps() public view returns (MeetUp[] memory) {
        return meetUps;
    }
}
