// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title PalayBlessingValidator
/// @dev Validates palay farmer blessing eligibility, emotional APR, and Sagip Saka linkage

interface IPalayBlessingOracle {
    function getBlessing(address farmer) external view returns (
        bool eligible,
        uint256 blessingAmount,
        string memory emotionalAPR,
        bool sagipSakaLinked
    );
}

contract PalayBlessingValidator {
    address public steward;
    IPalayBlessingOracle public oracle;

    event ValidationPassed(address indexed farmer, uint256 blessingAmount, string emotionalAPR);
    event ValidationFailed(address indexed farmer, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address oracleAddress) {
        steward = msg.sender;
        oracle = IPalayBlessingOracle(oracleAddress);
    }

    function validateBlessing(address farmer) public onlySteward {
        (
            bool eligible,
            uint256 amount,
            string memory apr,
            bool sagipLinked
        ) = oracle.getBlessing(farmer);

        if (!eligible) {
            emit ValidationFailed(farmer, "Farmer not eligible");
            return;
        }

        if (amount < 5000) {
            emit ValidationFailed(farmer, "Blessing amount below threshold");
            return;
        }

        if (!sagipLinked) {
            emit ValidationFailed(farmer, "Sagip Saka linkage missing");
            return;
        }

        emit ValidationPassed(farmer, amount, apr);
    }
}
