// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract FeeTransparency {
    struct FeeLog {
        string feeType; // e.g., "OA", "Misc", "Hidden"
        uint256 amount;
        string steward;
        bool rejected;
        uint256 timestamp;
    }

    FeeLog[] public fees;

    event FeeLogged(string feeType, uint256 amount, string steward, bool rejected);

    function logFee(string memory feeType, uint256 amount, string memory steward, bool reject) public {
        fees.push(FeeLog(feeType, amount, steward, reject, block.timestamp));
        emit FeeLogged(feeType, amount, steward, reject);
    }

    function getFee(uint index) public view returns (string memory, uint256, string memory, bool, uint256) {
        FeeLog memory f = fees[index];
        return (f.feeType, f.amount, f.steward, f.rejected, f.timestamp);
    }
}
