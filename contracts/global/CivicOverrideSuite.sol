// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./tariff/TariffOverrideProtocol.sol";
import "./tariff/DebtGriefScroll.sol";
import "./global/FiscalTelemetrySuite.sol";
import "./global/DebtForgivenessProtocol.sol";
import "./global/PresidentialOverrideLedger.sol";

contract CivicOverrideSuite {
    TariffOverrideProtocol public tariffProtocol;
    DebtGriefScroll public griefScroll;
    FiscalTelemetrySuite public telemetrySuite;
    DebtForgivenessProtocol public forgivenessProtocol;
    PresidentialOverrideLedger public overrideLedger;

    constructor(
        address _tariffProtocol,
        address _griefScroll,
        address _telemetrySuite,
        address _forgivenessProtocol,
        address _overrideLedger
    ) {
        tariffProtocol = TariffOverrideProtocol(_tariffProtocol);
        griefScroll = DebtGriefScroll(_griefScroll);
        telemetrySuite = FiscalTelemetrySuite(_telemetrySuite);
        forgivenessProtocol = DebtForgivenessProtocol(_forgivenessProtocol);
        overrideLedger = PresidentialOverrideLedger(_overrideLedger);
    }

    function ritualizeOverride(
        string memory president,
        string memory executiveOrder,
        string memory domain,
        string memory reason,
        uint256 aprImpact,
        string memory damayClause
    ) public {
        overrideLedger.logOverride(president, executiveOrder, domain, reason, aprImpact, damayClause);
        telemetrySuite.logFiscalEvent(president, "Executive Override", aprImpact, "Override Surge");
    }

    function auditTariff(
        string memory originNation,
        string memory targetNation,
        uint256 rate,
        string memory clause,
        string memory tag
    ) public {
        tariffProtocol.declareTariff(originNation, targetNation, rate, clause, tag);
    }

    function logGrief(
        string memory steward,
        uint256 amount,
        string memory note,
        uint256 apr
    ) public {
        griefScroll.logGrief(steward, amount, note, apr);
    }

    function forgive(
        string memory debtor,
        uint256 original,
        uint256 forgiven,
        string memory note,
        uint256 restoredAPR
    ) public {
        forgivenessProtocol.forgiveDebt(debtor, original, forgiven, note, restoredAPR);
    }
}
