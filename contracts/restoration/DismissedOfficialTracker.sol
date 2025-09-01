// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract DismissedOfficialTracker {
    struct Official {
        string name;
        string position;
        uint256 dateDismissed;
        bool underInvestigation;
        string reason;
        string assetTag;
    }

    mapping(address => Official) public dismissedOfficials;

    event OfficialLogged(
        address indexed officialAddress,
        string name,
        string position,
        bool underInvestigation,
        string reason,
        string assetTag
    );

    function logDismissedOfficial(
        address officialAddress,
        string memory name,
        string memory position,
        uint256 dateDismissed,
        bool underInvestigation,
        string memory reason,
        string memory assetTag
    ) public {
        dismissedOfficials[officialAddress] = Official(
            name,
            position,
            dateDismissed,
            underInvestigation,
            reason,
            assetTag
        );

        emit OfficialLogged(
            officialAddress,
            name,
            position,
            underInvestigation,
            reason,
            assetTag
        );
    }

    function getOfficial(address officialAddress) public view returns (Official memory) {
        return dismissedOfficials[officialAddress];
    }
}
