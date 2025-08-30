// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalDamayClause {
    struct Steward {
        string name;
        string region;
        string reasonForOpposition;
        uint256 timestamp;
        string emotionalAPRTag;
    }

    Steward[] public damayLog;

    event StewardLogged(string name, string region, string emotionalAPRTag);

    function logSteward(
        string memory name,
        string memory region,
        string memory reasonForOpposition,
        string memory emotionalAPRTag
    ) public {
        damayLog.push(Steward({
            name: name,
            region: region,
            reasonForOpposition: reasonForOpposition,
            timestamp: block.timestamp,
            emotionalAPRTag: emotionalAPRTag
        }));

        emit StewardLogged(name, region, emotionalAPRTag);
    }

    function getSteward(uint256 index) public view returns (Steward memory) {
        require(index < damayLog.length, "Invalid index");
        return damayLog[index];
    }

    function getTotalStewards() public view returns (uint256) {
        return damayLog.length;
    }
}
