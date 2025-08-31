// SPDX-License-Identifier: Sovereign-7
pragma solidity ^0.8.19;

/// @title RiceTariffRestoration.sol
/// @notice Logs farmer petitions to restore rice import tariff to 35%
contract RiceTariffRestoration {
    address public steward;
    uint256 public proposedTariff = 35;

    struct Petition {
        address farmer;
        string barangay;
        string reason;
        uint256 timestamp;
    }

    Petition[] public petitions;

    event TariffPetitioned(address indexed farmer, string barangay, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function submitPetition(string memory barangay, string memory reason) public {
        petitions.push(Petition(msg.sender, barangay, reason, block.timestamp));
        emit TariffPetitioned(msg.sender, barangay, reason);
    }

    function getPetition(uint256 index) public view returns (Petition memory) {
        require(index < petitions.length, "Scroll not found");
        return petitions[index];
    }

    function totalPetitions() public view returns (uint256) {
        return petitions.length;
    }

    function getProposedTariff() public view returns (uint256) {
        return proposedTariff;
    }
}
