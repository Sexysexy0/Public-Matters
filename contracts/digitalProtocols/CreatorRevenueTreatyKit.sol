// CreatorRevenueTreatyKit.sol
// Protocol for managing subtitle creator subscriptions and revenue shares

pragma solidity ^0.8.19;

contract CreatorRevenueTreatyKit {
    struct Creator {
        address steward;
        string tier;
        uint256 revenueSharePercent;
        uint256 totalEarnings;
        bool active;
    }

    mapping(address => Creator) public creators;

    function onboardCreator(string memory tier, uint256 share) public {
        require(share >= 15 && share <= 30, "Share must be between 15% and 30%");
        creators[msg.sender] = Creator(msg.sender, tier, share, 0, true);
    }

    function recordEarnings(address steward, uint256 amount) public {
        Creator storage c = creators[steward];
        require(c.active, "Inactive creator");
        uint256 share = (amount * c.revenueSharePercent) / 100;
        c.totalEarnings += share;
    }

    function getCreator(address steward) public view returns (Creator memory) {
        return creators[steward];
    }
}
