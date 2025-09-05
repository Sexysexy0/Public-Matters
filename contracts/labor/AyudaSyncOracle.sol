// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract AyudaSyncOracle {
    struct AyudaPackage {
        uint256 basePay;
        uint256 incentives;
        uint256 holidayRate;
        bool isSpecialHoliday;
        uint256 timestamp;
    }

    mapping(address => AyudaPackage[]) public ayudaLog;
    event AyudaSynced(address indexed steward, uint256 basePay, uint256 incentives, uint256 holidayRate, bool isSpecialHoliday);

    function syncAyuda(address steward, uint256 basePay, uint256 incentives, uint256 holidayRate, bool special) external {
        ayudaLog[steward].push(AyudaPackage(basePay, incentives, holidayRate, special, block.timestamp));
        emit AyudaSynced(steward, basePay, incentives, holidayRate, special);
    }

    function getLatestAyuda(address steward) external view returns (AyudaPackage memory) {
        uint256 len = ayudaLog[steward].length;
        require(len > 0, "No ayuda recorded");
        return ayudaLog[steward][len - 1];
    }
}
