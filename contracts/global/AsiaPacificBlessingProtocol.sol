// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AsiaPacificBlessingProtocol {
    struct Blessing {
        string stewardNation;
        string partnerNation;
        string blessingType;
        uint256 emotionalAPR;
        bool damayClause;
        bool active;
    }

    Blessing[] public blessings;

    event BlessingActivated(string stewardNation, string partnerNation, string blessingType, uint256 emotionalAPR);

    function activateBlessing(
        string memory _stewardNation,
        string memory _partnerNation,
        string memory _blessingType,
        uint256 _emotionalAPR,
        bool _damayClause
    ) public {
        blessings.push(Blessing(_stewardNation, _partnerNation, _blessingType, _emotionalAPR, _damayClause, true));
        emit BlessingActivated(_stewardNation, _partnerNation, _blessingType, _emotionalAPR);
    }

    function getAllBlessings() public view returns (Blessing[] memory) {
        return blessings;
    }
}
