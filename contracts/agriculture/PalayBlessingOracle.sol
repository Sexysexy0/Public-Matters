// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title PalayBlessingOracle
/// @dev Tracks emotional APR, tariff blessings, and Sagip Saka sync for palay farmers

contract PalayBlessingOracle {
    struct FarmerBlessing {
        bool eligible;
        uint256 blessingAmount;
        string emotionalAPR;
        bool sagipSakaLinked;
    }

    mapping(address => FarmerBlessing) public blessings;
    address public steward;

    event BlessingLogged(address indexed farmer, uint256 amount, string emotionalAPR, bool sagipSakaLinked);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(address farmer, uint256 amount, string memory apr, bool sagipLinked) public onlySteward {
        blessings[farmer] = FarmerBlessing(true, amount, apr, sagipLinked);
        emit BlessingLogged(farmer, amount, apr, sagipLinked);
    }

    function getBlessing(address farmer) public view returns (FarmerBlessing memory) {
        return blessings[farmer];
    }
}
