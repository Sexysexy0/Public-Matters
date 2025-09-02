// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title FamilyBlessingValidator
/// @dev Validates family blessing eligibility, threshold accuracy, and emotional APR sync

interface IFamilyBlessingOracle {
    function getBlessing(address family) external view returns (
        bool eligible,
        uint256 monthlyThreshold,
        uint256 blessingAmount,
        string memory emotionalAPR,
        bool overrideTriggered
    );
}

contract FamilyBlessingValidator {
    address public steward;
    IFamilyBlessingOracle public oracle;

    event ValidationPassed(address indexed family, uint256 blessingAmount, string emotionalAPR);
    event ValidationFailed(address indexed family, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address oracleAddress) {
        steward = msg.sender;
        oracle = IFamilyBlessingOracle(oracleAddress);
    }

    function validateBlessing(address family) public onlySteward {
        (
            bool eligible,
            uint256 threshold,
            uint256 amount,
            string memory apr,
            bool overrideFlag
        ) = oracle.getBlessing(family);

        if (!eligible) {
            emit ValidationFailed(family, "Family not eligible");
            return;
        }

        if (threshold < 16000) {
            emit ValidationFailed(family, "Threshold below barangay baseline");
            return;
        }

        if (amount < 5000) {
            emit ValidationFailed(family, "Blessing amount insufficient");
            return;
        }

        emit ValidationPassed(family, amount, apr);
    }
}
