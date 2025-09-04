// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LandBuyoutProtocol {
    struct LandOffer {
        address steward;
        uint256 ancestralValue;
        uint256 emotionalAPR;
        bool consented;
    }

    mapping(address => LandOffer) public offers;

    event OfferDeployed(address indexed steward, uint256 value, uint256 apr);
    event ConsentReceived(address indexed steward, bool consented);

    function deployOffer(uint256 _value, uint256 _apr) external {
        offers[msg.sender] = LandOffer(msg.sender, _value, _apr, false);
        emit OfferDeployed(msg.sender, _value, _apr);
    }

    function consentToBuyout() external {
        require(offers[msg.sender].ancestralValue > 0, "No offer found");
        offers[msg.sender].consented = true;
        emit ConsentReceived(msg.sender, true);
    }

    function auditOffer(address _steward) external view returns (LandOffer memory) {
        return offers[_steward];
    }
}
