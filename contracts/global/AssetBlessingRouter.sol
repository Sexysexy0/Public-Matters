// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract AssetBlessingRouter {
    address public steward;

    address public barangayInfraFund;
    address public sanctumUpgradeFund;
    address public ancestralRestorationFund;

    event AssetTaxRouted(address indexed vendor, uint256 amount, string destination);

    constructor(address _infra, address _sanctum, address _ancestral) {
        steward = msg.sender;
        barangayInfraFund = _infra;
        sanctumUpgradeFund = _sanctum;
        ancestralRestorationFund = _ancestral;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function routeAssetTax(address vendor, uint256 amount, string memory destination) external onlySteward {
        if (compare(destination, "barangay")) {
            payable(barangayInfraFund).transfer(amount);
        } else if (compare(destination, "sanctum")) {
            payable(sanctumUpgradeFund).transfer(amount);
        } else {
            payable(ancestralRestorationFund).transfer(amount);
        }
        emit AssetTaxRouted(vendor, amount, destination);
    }

    function compare(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    receive() external payable {}
}
