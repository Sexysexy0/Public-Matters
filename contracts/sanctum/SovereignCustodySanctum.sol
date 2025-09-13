// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SovereignCustodySanctum {
    enum CustodyType { ColdStorage, MultisigVault, HardwareWallet, AirgappedNode }
    enum RiskLevel { Low, Moderate, High, Critical }

    struct CustodySignal {
        uint256 id;
        CustodyType custodyType;
        RiskLevel riskLevel;
        string guardianTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => CustodySignal) public custodyRegistry;
    uint256 public custodyCount;

    event CustodyLogged(uint256 id, CustodyType custodyType, RiskLevel riskLevel);
    event RiskUpdated(uint256 id, RiskLevel newRiskLevel);

    function logCustody(
        CustodyType custodyType,
        RiskLevel riskLevel,
        string memory guardianTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        custodyRegistry[custodyCount] = CustodySignal(
            custodyCount,
            custodyType,
            riskLevel,
            guardianTag,
            clauseReference,
            timestamp
        );
        emit CustodyLogged(custodyCount, custodyType, riskLevel);
        custodyCount++;
    }

    function updateRiskLevel(uint256 id, RiskLevel newRiskLevel) public {
        require(id < custodyCount, "Invalid custody ID");
        custodyRegistry[id].riskLevel = newRiskLevel;
        emit RiskUpdated(id, newRiskLevel);
    }

    function getCustodySignal(uint256 id) public view returns (CustodySignal memory) {
        return custodyRegistry[id];
    }
}
