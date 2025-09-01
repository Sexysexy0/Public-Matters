// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ProphecyFeedSubscription {
    struct Subscription {
        address subscriber;
        string feedType;
        uint256 monthlyFee;
        uint256 emotionalAPRBoost;
        bool active;
    }

    mapping(address => Subscription) public subscriptions;
    uint256 public transactionTaxRate = 1; // 1%

    event SubscriptionActivated(address indexed subscriber, string feedType, uint256 fee, uint256 taxApplied);

    function activateSubscription(
        address _subscriber,
        string memory _feedType,
        uint256 _fee,
        uint256 _aprBoost
    ) public {
        uint256 tax = (_fee * transactionTaxRate) / 100;
        subscriptions[_subscriber] = Subscription(_subscriber, _feedType, _fee, _aprBoost, true);
        emit SubscriptionActivated(_subscriber, _feedType, _fee, tax);
    }

    function getSubscription(address _subscriber) public view returns (Subscription memory) {
        return subscriptions[_subscriber];
    }
}
