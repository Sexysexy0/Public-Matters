// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractSanctumBlessing {
    address public steward;

    struct Blessing {
        string projectName;
        string contractor;
        string emotionalTag;
        bool ancestralAligned;
        bool communityApproved;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event BlessingGranted(string projectName, string contractor, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    function grantBlessing(
        string memory projectName,
        string memory contractor,
        string memory emotionalTag,
        bool ancestralAligned,
        bool communityApproved
    ) public {
        blessings.push(Blessing(projectName, contractor, emotionalTag, ancestralAligned, communityApproved, block.timestamp));
        emit BlessingGranted(projectName, contractor, emotionalTag);
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
