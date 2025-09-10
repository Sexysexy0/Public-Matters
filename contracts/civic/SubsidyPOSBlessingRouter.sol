// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract SubsidyPOSBlessingRouter {
    struct Subsidy {
        address recipient;
        string itemCategory;
        uint256 discountRate;
        uint256 timestamp;
        bool redeemed;
    }

    mapping(address => Subsidy[]) public blessings;
    address public steward;

    event SubsidyRedeemed(address indexed recipient, string itemCategory, uint256 discountRate);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a subsidy steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerSubsidy(address _recipient, string memory _category, uint256 _rate) public onlySteward {
        blessings[_recipient].push(Subsidy(_recipient, _category, _rate, block.timestamp, false));
    }

    function redeemSubsidy(address _recipient, uint index) public onlySteward {
        require(!blessings[_recipient][index].redeemed, "Already redeemed");
        blessings[_recipient][index].redeemed = true;
        emit SubsidyRedeemed(_recipient, blessings[_recipient][index].itemCategory, blessings[_recipient][index].discountRate);
    }

    function getSubsidies(address _recipient) public view returns (Subsidy[] memory) {
        return blessings[_recipient];
    }
}
