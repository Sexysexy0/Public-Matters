// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EquityResonanceVault {
    struct Subscription {
        address subscriber;
        string tier;
        string benefit;
        uint256 timestamp;
        bool safeguarded;
    }

    Subscription[] public subs;

    event SubscriptionLogged(address indexed subscriber, string tier, string benefit);
    event SubscriptionSafeguarded(uint256 indexed id, address verifier);

    function logSubscription(string memory _tier, string memory _benefit) public {
        subs.push(Subscription(msg.sender, _tier, _benefit, block.timestamp, false));
        emit SubscriptionLogged(msg.sender, _tier, _benefit);
    }

    function safeguardSubscription(uint256 _id) public {
        require(_id < subs.length, "Invalid ID");
        subs[_id].safeguarded = true;
        emit SubscriptionSafeguarded(_id, msg.sender);
    }

    function getSubscription(uint256 _id) public view returns (Subscription memory) {
        require(_id < subs.length, "Invalid ID");
        return subs[_id];
    }

    function totalSubscriptions() public view returns (uint256) {
        return subs.length;
    }
}
