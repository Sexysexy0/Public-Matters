// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BarangayReliefValidator
/// @dev Validates LGU-level ayuda disbursements and emotional APR sync

interface IAyudaTrackingOracle {
    function getAyuda(address beneficiary) external view returns (
        bool received,
        uint256 amount,
        string memory program,
        string memory emotionalAPR,
        bool overrideTriggered
    );
}

contract BarangayReliefValidator {
    address public steward;
    IAyudaTrackingOracle public oracle;

    event ValidationPassed(address indexed beneficiary, string program, uint256 amount, string emotionalAPR);
    event ValidationFailed(address indexed beneficiary, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address oracleAddress) {
        steward = msg.sender;
        oracle = IAyudaTrackingOracle(oracleAddress);
    }

    function validateAyuda(address beneficiary) public onlySteward {
        (
            bool received,
            uint256 amount,
            string memory program,
            string memory apr,
            bool overrideFlag
        ) = oracle.getAyuda(beneficiary);

        if (!received) {
            emit ValidationFailed(beneficiary, "Ayuda not received");
            return;
        }

        if (amount < 1000) {
            emit ValidationFailed(beneficiary, "Amount below dignity threshold");
            return;
        }

        emit ValidationPassed(beneficiary, program, amount, apr);
    }
}
