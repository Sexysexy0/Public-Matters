// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract HopeToPersonRouter {
    struct APRTrack {
        string steward;
        uint256 despairLevel;
        uint256 hopeLevel;
        bool personhoodRestored;
    }

    mapping(address => APRTrack) public aprLog;

    event RestorationLogged(string steward, uint256 hopeLevel);

    function logHope(address stewardAddr, string memory steward, uint256 despair, uint256 hope) public {
        bool restored = hope > despair;
        aprLog[stewardAddr] = APRTrack(steward, despair, hope, restored);
        if (restored) {
            emit RestorationLogged(steward, hope);
        }
    }

    function getAPR(address stewardAddr) public view returns (APRTrack memory) {
        return aprLog[stewardAddr];
    }
}
