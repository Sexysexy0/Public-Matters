// SPDX-License-Identifier: MercySanctum
pragma solidity ^0.8.19;

contract FundingLegitimacyRouter {
    struct LegitimacySignal {
        address donorID;
        string donorName;
        string fundingPurpose;
        uint256 pledgedAmount;
        uint256 disbursedAmount;
        bool auditVerified;
        bool dignityCertified;
        string stewardNote;
    }

    mapping(address => LegitimacySignal) public legitimacyRegistry;

    event FundingTagged(address donorID, string fundingPurpose);
    event FundingVerified(address donorID);

    function tagFunding(address donorID, string memory donorName, string memory fundingPurpose, uint256 pledgedAmount, uint256 disbursedAmount, bool dignityCertified, string memory stewardNote) public {
        legitimacyRegistry[donorID] = LegitimacySignal(donorID, donorName, fundingPurpose, pledgedAmount, disbursedAmount, false, dignityCertified, stewardNote);
        emit FundingTagged(donorID, fundingPurpose);
    }

    function verifyFunding(address donorID) public {
        require(bytes(legitimacyRegistry[donorID].donorName).length > 0, "Donor not tagged");
        legitimacyRegistry[donorID].auditVerified = true;
        emit FundingVerified(donorID);
    }

    function getFundingStatus(address donorID) public view returns (LegitimacySignal memory) {
        return legitimacyRegistry[donorID];
    }
}
