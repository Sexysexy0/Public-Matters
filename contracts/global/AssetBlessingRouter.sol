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
            (bool success, ) = payable(barangayInfraFund).call{value: amount}(""); require(success, "Transfer failed");
        } else if (compare(destination, "sanctum")) {
            (bool success, ) = payable(sanctumUpgradeFund).call{value: amount}(""); require(success, "Transfer failed");
        } else {
            (bool success, ) = payable(ancestralRestorationFund).call{value: amount}(""); require(success, "Transfer failed");
        }
        emit AssetTaxRouted(vendor, amount, destination);
    }

    function compare(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    receive() external payable {}
}
