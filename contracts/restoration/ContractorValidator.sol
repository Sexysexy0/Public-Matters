// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ContractorValidator {
    event ContractorValidated(
        string companyName,
        bool isRegistered,
        bool hasPhysicalOffice,
        bool hasToolsAndMachines,
        bool hasSTE,
        bool hasCleanHistory,
        bool isEligible,
        uint256 timestamp
    );

    struct Contractor {
        string companyName;
        bool isRegistered;
        bool hasPhysicalOffice;
        bool hasToolsAndMachines;
        bool hasSTE; // Sustaining Technical Employees
        bool hasCleanHistory;
        bool isEligible;
        uint256 timestamp;
    }

    mapping(bytes32 => Contractor) public contractors;

    function validateContractor(
        string memory companyName,
        bool isRegistered,
        bool hasPhysicalOffice,
        bool hasToolsAndMachines,
        bool hasSTE,
        bool hasCleanHistory
    ) external {
        bool eligible = (
            isRegistered &&
            hasPhysicalOffice &&
            hasToolsAndMachines &&
            hasSTE &&
            hasCleanHistory
        );

        bytes32 contractorId = keccak256(abi.encodePacked(companyName, block.timestamp));
        contractors[contractorId] = Contractor(
            companyName,
            isRegistered,
            hasPhysicalOffice,
            hasToolsAndMachines,
            hasSTE,
            hasCleanHistory,
            eligible,
            block.timestamp
        );

        emit ContractorValidated(
            companyName,
            isRegistered,
            hasPhysicalOffice,
            hasToolsAndMachines,
            hasSTE,
            hasCleanHistory,
            eligible,
            block.timestamp
        );
    }

    function getContractor(bytes32 contractorId) external view returns (Contractor memory) {
        return contractors[contractorId];
    }
}
