// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LocalRevenueGuard {
    struct RevenueAllocation {
        uint256 totalRevenue;
        uint256 localShare; // 70% to local
        uint256 stateShare; // 30% to state
        bool isFinalized;
    }

    address public localTreasury;
    address public stateTreasury;
    uint256 public constant LOCAL_SHARE_BPS = 7000; // 70%
    uint256 public constant STATE_SHARE_BPS = 3000; // 30%

    event RevenueAllocated(uint256 total, uint256 local, uint256 state);
    event TreasuryUpdated(address indexed local, address indexed state);

    constructor(address _localTreasury, address _stateTreasury) {
        localTreasury = _localTreasury;
        stateTreasury = _stateTreasury;
    }

    function allocateRevenue(uint256 _amount) external {
        uint256 localAmount = (_amount * LOCAL_SHARE_BPS) / 10000;
        uint256 stateAmount = (_amount * STATE_SHARE_BPS) / 10000;

        // In production, these would be actual transfers
        // payable(localTreasury).transfer(localAmount);
        // payable(stateTreasury).transfer(stateAmount);

        emit RevenueAllocated(_amount, localAmount, stateAmount);
    }

    function updateTreasuries(address _local, address _state) external {
        // onlyOwner placeholder
        localTreasury = _local;
        stateTreasury = _state;
        emit TreasuryUpdated(_local, _state);
    }
}
