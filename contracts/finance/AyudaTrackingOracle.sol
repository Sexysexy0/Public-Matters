// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AyudaTrackingOracle
/// @dev Tracks real-time beneficiary sync, emotional APR, and override flags

contract AyudaTrackingOracle {
    struct Beneficiary {
        bool received;
        uint256 amount;
        string program;
        string emotionalAPR;
        bool overrideTriggered;
    }

    mapping(address => Beneficiary) public ayudaLedger;
    address public steward;

    event AyudaLogged(address indexed beneficiary, string program, uint256 amount, string emotionalAPR, bool overrideTriggered);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAyuda(address beneficiary, string memory program, uint256 amount, string memory apr, bool overrideFlag) public onlySteward {
        ayudaLedger[beneficiary] = Beneficiary(true, amount, program, apr, overrideFlag);
        emit AyudaLogged(beneficiary, program, amount, apr, overrideFlag);
    }

    function getAyuda(address beneficiary) public view returns (Beneficiary memory) {
        return ayudaLedger[beneficiary];
    }
}
