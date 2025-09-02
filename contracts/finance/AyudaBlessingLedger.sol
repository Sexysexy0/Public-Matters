// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AyudaBlessingLedger
/// @dev Logs all ayuda disbursements, emotional APR, and override sync for planetary audit

contract AyudaBlessingLedger {
    struct AyudaLog {
        string program;
        uint256 amount;
        string emotionalAPR;
        bool overrideTriggered;
        uint256 timestamp;
    }

    mapping(address => AyudaLog[]) public ledger;
    address public steward;

    event AyudaLogged(address indexed beneficiary, string program, uint256 amount, string emotionalAPR, bool overrideTriggered, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAyuda(address beneficiary, string memory program, uint256 amount, string memory apr, bool overrideFlag) public onlySteward {
        AyudaLog memory log = AyudaLog(program, amount, apr, overrideFlag, block.timestamp);
        ledger[beneficiary].push(log);
        emit AyudaLogged(beneficiary, program, amount, apr, overrideFlag, block.timestamp);
    }

    function getAyudaLogs(address beneficiary) public view returns (AyudaLog[] memory) {
        return ledger[beneficiary];
    }
}
