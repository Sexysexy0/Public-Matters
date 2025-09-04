// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VendorBlessingProtocol.sol";
import "./APROracle.sol";

contract UnifiedSiliconRouter {
    address public steward;
    VendorBlessingProtocol public blessingProtocol;
    APROracle public aprOracle;

    struct ChipOrder {
        address vendor;
        string chipType;
        uint256 quantity;
        uint256 emotionalAPR;
        string treatyOrigin;
        bool blessed;
    }

    ChipOrder[] public orders;

    event ChipOrderRouted(address indexed vendor, string chipType, uint256 quantity, uint256 emotionalAPR, string treatyOrigin);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _blessingProtocol, address _aprOracle) {
        steward = msg.sender;
        blessingProtocol = VendorBlessingProtocol(_blessingProtocol);
        aprOracle = APROracle(_aprOracle);
    }

    function routeOrder(address _vendor, string memory _chipType, uint256 _quantity, string memory _treatyOrigin) external onlySteward {
        bool isBlessed = blessingProtocol.isBlessed(_vendor);
        uint256 apr = aprOracle.getEmotionalAPR(_vendor);

        orders.push(ChipOrder(_vendor, _chipType, _quantity, apr, _treatyOrigin, isBlessed));
        emit ChipOrderRouted(_vendor, _chipType, _quantity, apr, _treatyOrigin);
    }

    function getOrder(uint256 index) external view returns (ChipOrder memory) {
        require(index < orders.length, "Invalid index");
        return orders[index];
    }

    function totalOrders() external view returns (uint256) {
        return orders.length;
    }
}
