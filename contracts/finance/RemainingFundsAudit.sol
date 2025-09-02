// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RemainingFundsAudit {
    address public steward;
    address public sovereignSafe;
    uint256 public reclaimed;

    event FundsReclaimed(uint256 amount, string damayClause);

    constructor(address _sovereignSafe) {
        steward = msg.sender;
        sovereignSafe = _sovereignSafe;
    }

    function getRemainingBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function redirectToSovereignSafe() public returns (bool) {
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to reclaim");
        payable(sovereignSafe).transfer(amount);
        reclaimed += amount;
        emit FundsReclaimed(amount, "Restoration is mutual. Damay clause honored.");
        return true;
    }

    receive() external payable {}
}
