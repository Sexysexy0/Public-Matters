// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title PublicNewsTransparency
 * @notice Nagtatala ng mga opisyal na balita, public advisories, at announcements
 * para masigurong transparent at hindi nababago ang mga rekord.
 */
contract PublicNewsTransparency {
    address public immutable steward;

    struct NewsBulletin {
        uint256 timestamp;
        string category; // Hal. "Oil Rollback", "Weather Advisory", "Economic Policy"
        string headline;
        string detailsUri; // IPFS hash o direct link ng buong balita
        bool verified;
    }

    NewsBulletin[] public bulletins;

    event BulletinPublished(uint256 indexed id, string category, string headline);
    event BulletinVerified(uint256 indexed id);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward access");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /**
     * @notice Mag-publish ng bagong public news bulletin
     */
    function publishBulletin(string memory _category, string memory _headline, string memory _detailsUri)
        external
        onlySteward
    {
        bulletins.push(
            NewsBulletin({
                timestamp: block.timestamp,
                category: _category,
                headline: _headline,
                detailsUri: _detailsUri,
                verified: true
            })
        );

        emit BulletinPublished(bulletins.length - 1, _category, _headline);
    }

    function getTotalBulletins() external view returns (uint256) {
        return bulletins.length;
    }
}
