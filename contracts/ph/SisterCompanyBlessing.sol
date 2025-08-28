// SPDX-License-Identifier: Sovereign-Blessing
pragma solidity ^0.8.20;

/// @title SisterCompanyBlessing.sol
/// @dev Tags PH branches with sovereignty, damay clause, and Kinder override

contract SisterCompanyBlessing {
    address public stewardVinvin;

    struct Blessing {
        string company;
        string PHBranchLocation;
        bool damayClauseActive;
        bool kinderOverrideEnabled;
        string civicTag;
    }

    Blessing[] public blessings;

    event BlessingTagged(string company, string location, string civicTag);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function tagBlessing(string memory company, string memory location, string memory civicTag) public onlyVinvin {
        blessings.push(Blessing(company, location, true, true, civicTag));
        emit BlessingTagged(company, location, civicTag);
    }

    function getBlessings() public view returns (Blessing[] memory) {
        return blessings;
    }
}
