// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BankFreezeRelay {
    address public steward;

    struct FreezeOrder {
        address wallet;
        string owner;
        string reason;
        bool frozen;
        uint256 timestamp;
    }

    FreezeOrder[] public orders;

    event WalletFrozen(address wallet, string owner, string reason);

    constructor() {
        steward = msg.sender;
    }

    function issueFreeze(address wallet, string memory owner, string memory reason) public {
        orders.push(FreezeOrder(wallet, owner, reason, true, block.timestamp));
        emit WalletFrozen(wallet, owner, reason);
    }

    function getFreezeOrder(uint256 index) public view returns (FreezeOrder memory) {
        return orders[index];
    }

    function totalFreezeOrders() public view returns (uint256) {
        return orders.length;
    }
}
