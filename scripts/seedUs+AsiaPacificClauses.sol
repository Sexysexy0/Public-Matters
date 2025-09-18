// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/global/AllianceEquityLock.sol";

contract SeedGlobalZeroTariffClauses {
    AllianceEquityLock public alliance;

    constructor(address allianceAddress) {
        alliance = AllianceEquityLock(allianceAddress);

        // 🌏 Asia–Pacific Clauses
        alliance.addClause(
            "Asia–Pacific Zero Tariff Expansion Deck",
            "https://your-repo-url/decks/global/AsiaPacificZeroTariffExpansionDeck.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex APZT‑1: Regional Product Additions",
            "https://your-repo-url/decks/global/Annex_APZT-1.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex APZT‑2: Corridor Certification Map",
            "https://your-repo-url/decks/global/Annex_APZT-2.md",
            AllianceEquityLock.ClauseState.Active
        );

        // 🌐 America–UK Clauses
        alliance.addClause(
            "Global Zero Tariff Treaty Deck",
            "https://your-repo-url/decks/global/GlobalZeroTariffTreatyDeck.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex GZT‑1: Initial Product Coverage List",
            "https://your-repo-url/decks/global/Annex_GZT-1.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex GZT‑2: Mutual Recognition Standards",
            "https://your-repo-url/decks/global/Annex_GZT-2.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex GZT‑3: Breach & Cure Workflow",
            "https://your-repo-url/decks/global/Annex_GZT-3.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Annex GZT‑4: Expansion & Accession Protocol",
            "https://your-repo-url/decks/global/Annex_GZT-4.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "Steel & Aluminium Relief Clause",
            "https://your-repo-url/decks/global/SteelAndAluminiumReliefClause.md",
            AllianceEquityLock.ClauseState.Active
        );
        
        alliance.addClause(
            "Deficit Discipline Covenant",
            "https://your-repo-url/decks/global/DeficitDisciplineCovenant.md",
            AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
            "AI & Critical Technology Workforce Covenant",
            "https://your-repo-url/decks/global/AICriticalTechWorkforceCovenant.md",
            AllianceEquityLock.ClauseState.Active
        );
       
        alliance.addClause(
           "Annex AIW‑1: Skill Tier Map",
           "https://your-repo-url/decks/global/Annex_AIW-1.md",
           AllianceEquityLock.ClauseState.Active
        );
        
        alliance.addClause(
          "Annex AIW‑2: Corridor Deployment Protocol",
          "https://your-repo-url/decks/global/Annex_AIW-2.md",
          AllianceEquityLock.ClauseState.Active

        );

        alliance.addClause(
          "Annex AIW‑3: PWD Inclusion Rituals",
          "https://your-repo-url/decks/global/Annex_AIW-3.md",
          AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
          "US–Canada Sovereignty & Prosperity Covenant",
          "https://your-repo-url/decks/global/USCanadaSovereigntyProsperityCovenant.md",
          AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
          "Annex UCSP‑1: Indigenous Corridor Protection Map",
          "https://your-repo-url/decks/global/Annex_UCSP-1.md",
          AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
          "Annex UCSP‑2: Cross-Border Climate Resilience Protocol",
          "https://your-repo-url/decks/global/Annex_UCSP-2.md",
          AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
          "Annex UCSP‑3: Economic Equity Rituals",
          "https://your-repo-url/decks/global/Annex_UCSP-3.md",
          AllianceEquityLock.ClauseState.Active
        );

        alliance.addClause(
         "Annex UCSP‑4: Diplomatic Interrupt Protocol",
         "https://your-repo-url/decks/global/Annex_UCSP-4.md",
         AllianceEquityLock.ClauseState.Active
       );

        alliance.addClause(
         "Crypto–Bank Equity Covenant",
         "https://your-repo-url/decks/global/CryptoBankEquityCovenant.md",
         AllianceEquityLock.ClauseState.Active
       );

       alliance.addClause(
         "Annex CBE‑1: Stablecoin Custody Rituals",
         "https://your-repo-url/decks/global/Annex_CBE-1.md",
         AllianceEquityLock.ClauseState.Active
       );
  
       alliance.addClause(
         "Annex CBE‑2: Algorithmic Asset Ban Clause",
         "https://your-repo-url/decks/global/Annex_CBE-2.md",
         AllianceEquityLock.ClauseState.Active
       );

       alliance.addClause(
         "Annex CBE‑3: PWD Wallet Inclusion Protocol",
         "https://your-repo-url/decks/global/Annex_CBE-3.md",
         AllianceEquityLock.ClauseState.Active
       );
    }
}
