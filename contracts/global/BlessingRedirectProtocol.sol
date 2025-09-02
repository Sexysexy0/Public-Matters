// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BlessingRedirectProtocol
/// @notice Deactivates legacy giveaways and redirects remaining assets to a sovereign safe
/// @dev Steward-controlled protocol for redirecting ETH blessings post-deactivation
contract BlessingRedirectProtocol {
    address public immutable steward;
    address public blessingSafe;
    bool public giveawaysDeactivated;

    event BlessingsRedirected(uint256 amount, address indexed to);
    event GiveawaysDeactivated(address indexed steward);
    event BlessingSafeUpdated(address indexed oldSafe, address indexed newSafe);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized: steward only");
        _;
    }

    /// @param _blessingSafe Initial safe address to receive redirected blessings
    constructor(address _blessingSafe) {
        require(_blessingSafe != address(0), "Invalid blessingSafe address");
        steward = msg.sender;
        blessingSafe = _blessingSafe;
        giveawaysDeactivated = false;
    }

    /// @notice Deactivates all giveaway functions permanently
    function deactivateGiveaways() external onlySteward {
        require(!giveawaysDeactivated, "Giveaways already deactivated");
        giveawaysDeactivated = true;
        emit GiveawaysDeactivated(steward);
    }

    /// @notice Redirects all ETH blessings to the designated safe
    function redirectBlessings() external onlySteward {
        require(giveawaysDeactivated, "Deactivate giveaways first");
        uint256 balance = address(this).balance;
        require(balance > 0, "No blessings to redirect");

        (bool success, ) = blessingSafe.call{value: balance}("");
        require(success, "Blessing redirect failed");

        emit BlessingsRedirected(balance, blessingSafe);
    }

    /// @notice Updates the blessingSafe address (if needed)
    /// @param newSafe New address to receive blessings
    function updateBlessingSafe(address newSafe) external onlySteward {
        require(newSafe != address(0), "Invalid newSafe address");
        address oldSafe = blessingSafe;
        blessingSafe = newSafe;
        emit BlessingSafeUpdated(oldSafe, newSafe);
    }

    /// @notice Accepts ETH blessings
    receive() external payable {}

    /// @notice Fallback to accept unexpected calls with ETH
    fallback() external payable {}
}
