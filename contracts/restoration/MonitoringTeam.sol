// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract MonitoringTeam {
    event SiteChecked(
        uint256 siteId,
        string siteName,
        address checker,
        bool isCompliant,
        string remarks,
        uint256 timestamp
    );

    struct Site {
        string siteName;
        bool isCompliant;
        string remarks;
        uint256 lastChecked;
    }

    mapping(uint256 => Site) public sites;
    mapping(address => bool) public authorizedCheckers;

    modifier onlyChecker() {
        require(authorizedCheckers[msg.sender], "Not an authorized checker");
        _;
    }

    function authorizeChecker(address checker) external {
        // Add role-based access control in production
        authorizedCheckers[checker] = true;
    }

    function logSiteCheck(
        uint256 siteId,
        string memory siteName,
        bool isCompliant,
        string memory remarks
    ) external onlyChecker {
        sites[siteId] = Site(siteName, isCompliant, remarks, block.timestamp);

        emit SiteChecked(
            siteId,
            siteName,
            msg.sender,
            isCompliant,
            remarks,
            block.timestamp
        );
    }

    function getSiteStatus(uint256 siteId) external view returns (Site memory) {
        return sites[siteId];
    }
}
