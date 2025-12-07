// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * ROWFinanceEquityGuardrailIV — Batch 1321.9.261
 * Focus: right-of-way (ROW), cost transparency, lifecycle finance, equity
 */
contract ROWFinanceEquityGuardrailIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Finance {
        uint256 capex;
        uint256 opexAnnual;
        uint256 maintenanceAnnual;
        bool fundingSecured;
        bool equityImpactAssessed; // small business, commuters, local economy
    }

    mapping(bytes32 => Finance) public finances;

    event FinanceSet(bytes32 indexed key, uint256 capex, uint256 opexAnnual, uint256 maintenanceAnnual, bool fundingSecured, bool equityImpactAssessed);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory lineId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(lineId));
    }

    function setFinance(
        string calldata lineId,
        uint256 capex,
        uint256 opexAnnual,
        uint256 maintenanceAnnual,
        bool fundingSecured,
        bool equityImpactAssessed
    ) external onlySteward {
        bytes32 k = keyFor(lineId);
        finances[k] = Finance(capex, opexAnnual, maintenanceAnnual, fundingSecured, equityImpactAssessed);
        emit FinanceSet(k, capex, opexAnnual, maintenanceAnnual, fundingSecured, equityImpactAssessed);
    }
}
