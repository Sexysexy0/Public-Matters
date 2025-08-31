// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

interface IBitMarketGatekeeper {
    function validateAccess(string memory _actor, string memory _sanctum) external returns (bool);
}

contract BitMarketTransactionRouter {
    address public gatekeeper;

    struct Transaction {
        string actor;
        string sanctum;
        string asset;
        uint amount;
        uint timestamp;
        bool routed;
    }

    Transaction[] public routedTransactions;

    event TransactionRouted(string actor, string asset, uint amount);
    event TransactionBlocked(string actor, string reason);

    constructor(address _gatekeeper) {
        gatekeeper = _gatekeeper;
    }

    function routeTransaction(
        string memory _actor,
        string memory _sanctum,
        string memory _asset,
        uint _amount
    ) public {
        bool accessGranted = IBitMarketGatekeeper(gatekeeper).validateAccess(_actor, _sanctum);

        if (!accessGranted) {
            emit TransactionBlocked(_actor, "Access denied by gatekeeper");
            return;
        }

        routedTransactions.push(Transaction(_actor, _sanctum, _asset, _amount, block.timestamp, true));
        emit TransactionRouted(_actor, _asset, _amount);
    }

    function getAllRoutedTransactions() public view returns (Transaction[] memory) {
        return routedTransactions;
    }
}
