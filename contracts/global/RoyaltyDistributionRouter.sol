// SPDX-License-Identifier: RoyaltySanctum
pragma solidity ^0.8.19;

contract RoyaltyDistributionRouter {
    struct RoyaltySignal {
        string assetID;
        address[] recipients;
        uint256[] percentages; // Must total 100
        bool active;
        string stewardNote;
    }

    mapping(string => RoyaltySignal) public royaltyRegistry;

    event RoyaltyTagged(string assetID);
    event RoyaltyActivated(string assetID);

    function tagRoyalty(string memory assetID, address[] memory recipients, uint256[] memory percentages, string memory stewardNote) public {
        require(recipients.length == percentages.length, "Mismatch in recipients and percentages");
        uint256 total;
        for (uint256 i = 0; i < percentages.length; i++) {
            total += percentages[i];
        }
        require(total == 100, "Percentages must total 100");

        royaltyRegistry[assetID] = RoyaltySignal(assetID, recipients, percentages, false, stewardNote);
        emit RoyaltyTagged(assetID);
    }

    function activateRoyalty(string memory assetID) public {
        require(bytes(royaltyRegistry[assetID].assetID).length > 0, "Asset not tagged");
        royaltyRegistry[assetID].active = true;
        emit RoyaltyActivated(assetID);
    }

    function getRoyaltyStatus(string memory assetID) public view returns (RoyaltySignal memory) {
        return royaltyRegistry[assetID];
    }
}
