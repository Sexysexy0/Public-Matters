// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title FamilyBlessingOracle
/// @dev Logs blessing eligibility, emotional APR, and cost-of-living sync for families

contract FamilyBlessingOracle {
    struct FamilyBlessing {
        bool eligible;
        uint256 monthlyThreshold;
        uint256 blessingAmount;
        string emotionalAPR;
        bool overrideTriggered;
    }

    mapping(address => FamilyBlessing) public blessings;
    address public steward;

    event BlessingLogged(address indexed family, uint256 amount, string emotionalAPR, bool overrideTriggered);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(address family, uint256 threshold, uint256 amount, string memory apr, bool overrideFlag) public onlySteward {
        blessings[family] = FamilyBlessing(true, threshold, amount, apr, overrideFlag);
        emit BlessingLogged(family, amount, apr, overrideFlag);
    }

    function getBlessing(address family) public view returns (FamilyBlessing memory) {
        return blessings[family];
    }
}
