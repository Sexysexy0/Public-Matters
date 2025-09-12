// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GenderEquityBlessingRouter {
    enum EquityAction { WageParity, BoardInclusion, SafetyProtocol, MaternitySupport }

    struct EquitySignal {
        uint256 id;
        string organization;
        EquityAction action;
        uint256 budgetAllocated;
        string blessingClause;
        uint256 timestamp;
    }

    mapping(uint256 => EquitySignal) public equityRegistry;
    uint256 public equityCount;

    event EquityLogged(uint256 id, string organization, EquityAction action);

    function logEquity(
        string memory organization,
        EquityAction action,
        uint256 budgetAllocated,
        string memory blessingClause,
        uint256 timestamp
    ) public {
        equityRegistry[equityCount] = EquitySignal(
            equityCount,
            organization,
            action,
            budgetAllocated,
            blessingClause,
            timestamp
        );
        emit EquityLogged(equityCount, organization, action);
        equityCount++;
    }

    function getEquity(uint256 id) public view returns (EquitySignal memory) {
        return equityRegistry[id];
    }
}
