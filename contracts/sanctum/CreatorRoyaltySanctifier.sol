// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreatorRoyaltySanctifier {
    struct RoyaltyRecord {
        uint256 id;
        address creator;
        string title;
        uint256 percentage;
        uint256 timestamp;
    }

    mapping(uint256 => RoyaltyRecord) public royaltyRegistry;
    uint256 public royaltyCount;

    event RoyaltyLogged(uint256 id, address creator, string title, uint256 percentage);

    function logRoyalty(
        address creator,
        string memory title,
        uint256 percentage,
        uint256 timestamp
    ) public {
        royaltyRegistry[royaltyCount] = RoyaltyRecord(
            royaltyCount,
            creator,
            title,
            percentage,
            timestamp
        );
        emit RoyaltyLogged(royaltyCount, creator, title, percentage);
        royaltyCount++;
    }

    function getRoyalty(uint256 id) public view returns (RoyaltyRecord memory) {
        return royaltyRegistry[id];
    }
}
