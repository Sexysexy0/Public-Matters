// SPDX-License-Identifier: Treaty-Grade
pragma solidity ^0.8.0;

contract GlobalBlessingLedgerExplorer {
    struct Blessing {
        string region;
        string sanctum;
        string purpose;
        uint256 amount;
        uint256 timestamp;
    }

    Blessing[] public globalBlessings;
    address public steward;

    event BlessingLogged(string region, string sanctum, string purpose, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Not a global steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(string memory _region, string memory _sanctum, string memory _purpose, uint256 _amount) public onlySteward {
        globalBlessings.push(Blessing(_region, _sanctum, _purpose, _amount, block.timestamp));
        emit BlessingLogged(_region, _sanctum, _purpose, _amount);
    }

    function getBlessings() public view returns (Blessing[] memory) {
        return globalBlessings;
    }

    function totalGlobalBlessings() public view returns (uint256 sum) {
        for (uint i = 0; i < globalBlessings.length; i++) {
            sum += globalBlessings[i].amount;
        }
    }
}
