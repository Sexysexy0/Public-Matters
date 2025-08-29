// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractorClusterAudit {
    address public steward;

    struct Contractor {
        string name;
        address wallet;
        string backendOps;
        bool flagged;
    }

    Contractor[] public contractors;

    event ClusterFlagged(string name, string backendOps);

    constructor() {
        steward = msg.sender;
    }

    function registerContractor(string memory name, address wallet, string memory backendOps) public {
        bool flagged = false;

        for (uint256 i = 0; i < contractors.length; i++) {
            if (keccak256(bytes(contractors[i].backendOps)) == keccak256(bytes(backendOps))) {
                flagged = true;
                emit ClusterFlagged(name, backendOps);
                break;
            }
        }

        contractors.push(Contractor(name, wallet, backendOps, flagged));
    }

    function getContractor(uint256 index) public view returns (Contractor memory) {
        return contractors[index];
    }

    function totalContractors() public view returns (uint256) {
        return contractors.length;
    }
}
