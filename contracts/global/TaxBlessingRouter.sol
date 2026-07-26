// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract TaxBlessingRouter {
    address public steward;

    address public ayudaPool;
    address public energyGridFund;
    address public sovereignSafe;

    event TaxRouted(address indexed vendor, uint256 amount, string destination);

    constructor(address _ayuda, address _energy, address _safe) {
        steward = msg.sender;
        ayudaPool = _ayuda;
        energyGridFund = _energy;
        sovereignSafe = _safe;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function routeTax(address vendor, uint256 amount, string memory destination) external onlySteward {
        if (compare(destination, "ayuda")) {
            (bool success, ) = payable(ayudaPool).call{value: amount}(""); require(success, "Transfer failed");
        } else if (compare(destination, "energy")) {
            (bool success, ) = payable(energyGridFund).call{value: amount}(""); require(success, "Transfer failed");
        } else {
            (bool success, ) = payable(sovereignSafe).call{value: amount}(""); require(success, "Transfer failed");
        }
        emit TaxRouted(vendor, amount, destination);
    }

    function compare(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    receive() external payable {}
}
