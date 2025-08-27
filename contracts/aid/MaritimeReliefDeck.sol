// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.27;

contract MaritimeReliefDeck {
    address public steward;
    mapping(address => uint256) public reliefLedger;

    event ReliefLogged(address beneficiary, uint256 amount);
    event ReliefDisbursed(address beneficiary, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logRelief(address beneficiary, uint256 amount) external onlySteward {
        reliefLedger[beneficiary] += amount;
        emit ReliefLogged(beneficiary, amount);
    }

    function disburseRelief(address beneficiary) external onlySteward {
        uint256 amount = reliefLedger[beneficiary];
        require(amount > 0, "No relief logged.");
        payable(beneficiary).transfer(amount);
        reliefLedger[beneficiary] = 0;
        emit ReliefDisbursed(beneficiary, amount);
    }

    function getReliefAmount(address beneficiary) external view returns (uint256) {
        return reliefLedger[beneficiary];
    }
}
