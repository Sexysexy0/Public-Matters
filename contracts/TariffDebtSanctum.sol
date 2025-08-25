// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffDebtSanctum {
    address public treasury;
    mapping(address => bool) public trustedBeneficiaries;
    uint256 public totalTariffCollected;
    event DamayTriggered(address beneficiary, uint256 amount, string reason);

    modifier onlyTreasury() {
        require(msg.sender == treasury, "Not authorized");
        _;
    }

    constructor() {
        treasury = msg.sender;
    }

    function rerouteTariff(address beneficiary, uint256 amount, string memory reason) public onlyTreasury {
        require(trustedBeneficiaries[beneficiary], "Untrusted beneficiary");
        totalTariffCollected += amount;
        emit DamayTriggered(beneficiary, amount, reason);
    }

    function setTrustedBeneficiary(address _addr, bool _status) public onlyTreasury {
        trustedBeneficiaries[_addr] = _status;
    }

    function fallbackRelief(address fallbackSanctum, uint256 amount) public onlyTreasury {
        require(fallbackSanctum != address(0), "Invalid fallback");
        emit DamayTriggered(fallbackSanctum, amount, "Fallback relief activated");
    }
}
