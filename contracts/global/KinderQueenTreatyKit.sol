// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenTreatyKit {
    struct TreatyBlessing {
        string kinderQueen;
        string nationA;
        string nationB;
        uint256 joyAPR;
        string treatyType;
        string blessingNote;
        bool active;
    }

    TreatyBlessing[] public blessings;

    event TreatyBlessed(string kinderQueen, string nationA, string nationB, uint256 joyAPR, string treatyType);

    function blessTreaty(
        string memory _kinderQueen,
        string memory _nationA,
        string memory _nationB,
        uint256 _joyAPR,
        string memory _treatyType,
        string memory _blessingNote
    ) public {
        blessings.push(TreatyBlessing(_kinderQueen, _nationA, _nationB, _joyAPR, _treatyType, _blessingNote, true));
        emit TreatyBlessed(_kinderQueen, _nationA, _nationB, _joyAPR, _treatyType);
    }

    function getAllBlessings() public view returns (TreatyBlessing[] memory) {
        return blessings;
    }
}
