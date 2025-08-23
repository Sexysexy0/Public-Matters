// SPDX-License-Identifier: Startup-Visa-Blessing-License  
pragma solidity ^0.8.19;

contract StartupVisaBlessing {
    struct VisaBlessing {
        string founderName;
        string destinationCountry;
        string startupName;
        bool approved;
        uint timestamp;
    }

    VisaBlessing[] public blessingLog;

    event VisaBlessed(string founderName, string destinationCountry);

    function blessVisa(
        string memory founderName,
        string memory destinationCountry,
        string memory startupName
    ) public {
        blessingLog.push(VisaBlessing(
            founderName,
            destinationCountry,
            startupName,
            true,
            block.timestamp
        ));
        emit VisaBlessed(founderName, destinationCountry);
    }

    function getBlessing(uint index) public view returns (VisaBlessing memory) {
        require(index < blessingLog.length, "Invalid index");
        return blessingLog[index];
    }

    function totalBlessings() public view returns (uint) {
        return blessingLog.length;
    }
}
