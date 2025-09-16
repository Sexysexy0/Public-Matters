// SPDX-License-Identifier: InvestorSanctum
pragma solidity ^0.8.19;

contract InvestorFastTrackPass {
    struct InvestorProfile {
        address wallet;
        string name;
        string sector; // e.g., "Tech", "Agri", "Infra", "AI"
        bool isWorking;
        bool incomeGenerating;
        bool protectedStatus;
        string stewardNote;
    }

    mapping(address => InvestorProfile) public investorRegistry;

    event InvestorTagged(address wallet, string sector);
    event ProtectionActivated(address wallet);

    function tagInvestor(address wallet, string memory name, string memory sector, bool isWorking, bool incomeGenerating, string memory stewardNote) public {
        investorRegistry[wallet] = InvestorProfile(wallet, name, sector, isWorking, incomeGenerating, false, stewardNote);
        emit InvestorTagged(wallet, sector);
    }

    function activateProtection(address wallet) public {
        require(investorRegistry[wallet].isWorking, "Investor must be actively working");
        require(investorRegistry[wallet].incomeGenerating, "Investor must be generating income");
        investorRegistry[wallet].protectedStatus = true;
        emit ProtectionActivated(wallet);
    }

    function getInvestorStatus(address wallet) public view returns (InvestorProfile memory) {
        return investorRegistry[wallet];
    }
}
