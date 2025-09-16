// SPDX-License-Identifier: DonorSanctum
pragma solidity ^0.8.19;

contract DonorTrustRouter {
    struct DonorSignal {
        address donorID;
        string donorName;
        string fundingPurpose;
        uint256 pledgedAmount;
        uint256 disbursedAmount;
        bool verified;
        string stewardNote;
    }

    mapping(address => DonorSignal) public donorRegistry;

    event DonorTagged(address donorID, string fundingPurpose);
    event DonorVerified(address donorID);

    function tagDonor(address donorID, string memory donorName, string memory fundingPurpose, uint256 pledgedAmount, uint256 disbursedAmount, string memory stewardNote) public {
        donorRegistry[donorID] = DonorSignal(donorID, donorName, fundingPurpose, pledgedAmount, disbursedAmount, false, stewardNote);
        emit DonorTagged(donorID, fundingPurpose);
    }

    function verifyDonor(address donorID) public {
        require(bytes(donorRegistry[donorID].donorName).length > 0, "Donor not tagged");
        donorRegistry[donorID].verified = true;
        emit DonorVerified(donorID);
    }

    function getDonorStatus(address donorID) public view returns (DonorSignal memory) {
        return donorRegistry[donorID];
    }
}
