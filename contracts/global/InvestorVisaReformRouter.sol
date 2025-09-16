// SPDX-License-Identifier: VisaSanctum
pragma solidity ^0.8.19;

contract InvestorVisaReformRouter {
    struct VisaProfile {
        address wallet;
        string name;
        string sector;
        bool isWorking;
        bool incomeGenerating;
        bool protectedStatus;
        bool flaggedByComplaint;
        string stewardNote;
    }

    mapping(address => VisaProfile) public visaRegistry;

    event VisaTagged(address wallet, string sector);
    event ComplaintFlagged(address wallet);
    event ProtectionActivated(address wallet);

    function tagVisa(address wallet, string memory name, string memory sector, bool isWorking, bool incomeGenerating, string memory stewardNote) public {
        visaRegistry[wallet] = VisaProfile(wallet, name, sector, isWorking, incomeGenerating, true, false, stewardNote);
        emit VisaTagged(wallet, sector);
    }

    function flagComplaint(address wallet) public {
        require(visaRegistry[wallet].protectedStatus, "Investor not protected");
        visaRegistry[wallet].flaggedByComplaint = true;
        emit ComplaintFlagged(wallet);
    }

    function activateProtection(address wallet) public {
        require(visaRegistry[wallet].isWorking && visaRegistry[wallet].incomeGenerating, "Investor must be active and contributing");
        visaRegistry[wallet].protectedStatus = true;
        emit ProtectionActivated(wallet);
    }

    function getVisaStatus(address wallet) public view returns (VisaProfile memory) {
        return visaRegistry[wallet];
    }
}
