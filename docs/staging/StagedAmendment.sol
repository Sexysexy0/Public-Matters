// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StagedAmendment {
    struct AmendmentDraft {
        string sector;
        string description;
        uint256 proposedAmount;
        bool includesDamayClause;
        bool barangayTagged;
        uint256 timestamp;
    }

    AmendmentDraft[] public drafts;
    address public steward;

    event AmendmentDrafted(string sector, string description, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function submitDraft(
        string memory sector,
        string memory description,
        uint256 amount,
        bool damay,
        bool tagged
    ) external {
        require(msg.sender == steward, "Unauthorized steward");

        drafts.push(AmendmentDraft(sector, description, amount, damay, tagged, block.timestamp));
        emit AmendmentDrafted(sector, description, amount);
    }

    function getDraft(uint256 index) external view returns (AmendmentDraft memory) {
        return drafts[index];
    }

    function totalDrafts() external view returns (uint256) {
        return drafts.length;
    }
}
