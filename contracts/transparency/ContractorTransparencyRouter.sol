// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractorTransparencyRouter {
    struct ContractorRecord {
        string contractorId;
        string name;
        string project;
        uint256 bidAmount;
        bool dummyFlagged;
        bool favoritismFlagged;
        uint256 timestamp;
    }

    mapping(string => ContractorRecord) public contractorLedger;

    event ContractorLogged(string contractorId, string name, string project, uint256 bidAmount);

    function logContractor(
        string memory contractorId,
        string memory name,
        string memory project,
        uint256 bidAmount,
        bool dummyFlagged,
        bool favoritismFlagged
    ) public {
        contractorLedger[contractorId] = ContractorRecord(
            contractorId,
            name,
            project,
            bidAmount,
            dummyFlagged,
            favoritismFlagged,
            block.timestamp
        );

        emit ContractorLogged(contractorId, name, project, bidAmount);
    }

    function getContractorDetails(string memory contractorId) public view returns (ContractorRecord memory) {
        return contractorLedger[contractorId];
    }
}
