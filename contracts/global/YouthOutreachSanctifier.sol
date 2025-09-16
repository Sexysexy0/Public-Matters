// SPDX-License-Identifier: YouthSanctum
pragma solidity ^0.8.19;

contract YouthOutreachSanctifier {
    struct OutreachProgram {
        string schoolID;
        string region;
        string campaignTheme;
        uint256 participantCount;
        bool completed;
        string stewardNote;
    }

    mapping(string => OutreachProgram) public outreachRegistry;

    event CampaignTagged(string schoolID, string campaignTheme);
    event OutreachSanctified(string schoolID);

    function tagCampaign(string memory schoolID, string memory region, string memory campaignTheme, uint256 participantCount, string memory stewardNote) public {
        outreachRegistry[schoolID] = OutreachProgram(schoolID, region, campaignTheme, participantCount, false, stewardNote);
        emit CampaignTagged(schoolID, campaignTheme);
    }

    function sanctifyOutreach(string memory schoolID) public {
        require(outreachRegistry[schoolID].participantCount > 0, "No participants registered");
        outreachRegistry[schoolID].completed = true;
        emit OutreachSanctified(schoolID);
    }

    function getOutreachStatus(string memory schoolID) public view returns (OutreachProgram memory) {
        return outreachRegistry[schoolID];
    }
}
