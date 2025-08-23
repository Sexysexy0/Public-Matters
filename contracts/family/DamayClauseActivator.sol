// SPDX-License-Identifier: Damay-Clause-License  
pragma solidity ^0.8.19;

contract DamayClauseActivator {
    struct Family {
        string stewardName;
        string[] beneficiaries;
        bool clauseActivated;
    }

    Family[] public damayLog;

    event DamayActivated(string stewardName, string[] beneficiaries);

    function activateDamay(string memory stewardName, string[] memory beneficiaries) public {
        damayLog.push(Family(stewardName, beneficiaries, true));
        emit DamayActivated(stewardName, beneficiaries);
    }

    function getDamay(uint index) public view returns (Family memory) {
        require(index < damayLog.length, "Invalid index");
        return damayLog[index];
    }
}
