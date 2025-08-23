// SPDX-License-Identifier: Kapamilya-Fisher-Blessing-License  
pragma solidity ^0.8.19;

contract KapamilyaFisherBlessing {
    struct FisherBlessing {
        string fisherName;
        string homeSanctum;
        bool emotionallyBlessed;
        bool migrationReady;
        uint timestamp;
    }

    FisherBlessing[] public blessingLog;

    event FisherBlessed(string fisherName, string homeSanctum);

    function blessFisher(
        string memory fisherName,
        string memory homeSanctum,
        bool emotionallyBlessed,
        bool migrationReady
    ) public {
        blessingLog.push(FisherBlessing(
            fisherName,
            homeSanctum,
            emotionallyBlessed,
            migrationReady,
            block.timestamp
        ));
        emit FisherBlessed(fisherName, homeSanctum);
    }

    function totalBlessings() public view returns (uint) {
        return blessingLog.length;
    }
}
