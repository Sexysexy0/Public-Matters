// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

interface BitMarketProfile {
    function getVendorAssets(address vendor) external view returns (
        uint256 landValue,
        uint256 equipmentValue,
        uint256 inventoryValue
    );
}

contract BitMarketAssetSync {
    address public steward;
    BitMarketProfile public profileContract;

    event AssetsSynced(address indexed vendor, uint256 land, uint256 equipment, uint256 inventory);

    constructor(address _profileContract) {
        steward = msg.sender;
        profileContract = BitMarketProfile(_profileContract);
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function syncAssets(address vendor) external onlySteward {
        (
            uint256 land,
            uint256 equipment,
            uint256 inventory
        ) = profileContract.getVendorAssets(vendor);

        emit AssetsSynced(vendor, land, equipment, inventory);
        // Optional: forward to AssetTaxBlessingProtocol.sol for auto-tax update
    }
}
