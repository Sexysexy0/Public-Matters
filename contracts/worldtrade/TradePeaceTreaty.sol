// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TropaTreaty {
    struct Treaty {
        string stewardNation;
        string neighborNation;
        uint256 emotionalAPR;
        string blessingClause;
        bool overrideEnabled;
        bool active;
    }

    Treaty[] public treaties;

    event TreatyBlessed(string stewardNation, string neighborNation, uint256 emotionalAPR, string blessingClause);

    function blessTropaTreaty(
        string memory _stewardNation,
        string memory _neighborNation,
        uint256 _emotionalAPR,
        string memory _blessingClause
    ) public {
        treaties.push(Treaty(_stewardNation, _neighborNation, _emotionalAPR, _blessingClause, true, true));
        emit TreatyBlessed(_stewardNation, _neighborNation, _emotionalAPR, _blessingClause);
    }

    function getAllTreaties() public view returns (Treaty[] memory) {
        return treaties;
    }
}
