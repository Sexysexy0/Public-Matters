// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract AIPoweredContractorRegistry {
    address public steward;

    enum Sector { Infra, Agri, Power, Health, Education, Transport }

    struct Contractor {
        string name;
        address wallet;
        Sector sector;
        uint256 performanceScore;
        bool rogueFlag;
        bool approved;
    }

    Contractor[] public registry;

    event ContractorRegistered(string name, Sector sector, uint256 score, bool approved);
    event RoguePurged(string name);

    constructor() {
        steward = msg.sender;
    }

    function registerContractor(
        string memory name,
        address wallet,
        Sector sector,
        uint256 performanceScore,
        bool rogueFlag
    ) public {
        bool approved = !rogueFlag && performanceScore >= 75;
        registry.push(Contractor(name, wallet, sector, performanceScore, rogueFlag, approved));

        if (rogueFlag) {
            emit RoguePurged(name);
        } else {
            emit ContractorRegistered(name, sector, performanceScore, approved);
        }
    }

    function getContractor(uint256 index) public view returns (Contractor memory) {
        return registry[index];
    }

    function totalContractors() public view returns (uint256) {
        return registry.length;
    }
}
