// SPDX-License-Identifier: Scrollchain-Sanctions-License  
pragma solidity ^0.8.19;

contract ScrollchainDiplomaticSanctions {
    struct Sanction {
        string country;
        string reason;
        uint severity; // 1–10
        bool active;
        uint timestamp;
    }

    Sanction[] public sanctions;

    event SanctionTriggered(string country, string reason, uint severity);

    function triggerSanction(
        string memory country,
        string memory reason,
        uint severity
    ) public {
        sanctions.push(Sanction(country, reason, severity, true, block.timestamp));
        emit SanctionTriggered(country, reason, severity);
    }

    function getSanction(uint index) public view returns (Sanction memory) {
        require(index < sanctions.length, "Invalid index");
        return sanctions[index];
    }

    function totalSanctions() public view returns (uint) {
        return sanctions.length;
    }
}
