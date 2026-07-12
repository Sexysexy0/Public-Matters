// SPDX-License-Identifier: MIT
// Contract Name: GuildKeepCovenant
// Purpose: Encode systemic safeguards for guild councils, keep frameworks, and governance towers that preserve cooperative traditions and collective guardianship
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GuildKeepCovenant {
    address public chiefOperator;

    struct GuildRecord {
        string principle;   // e.g. Guild councils, Keep frameworks, Governance towers
        string dilemma;     // e.g. Tradition erosion, Weak guardianship, Crisis neglect
        string safeguard;   // e.g. Keep audits, Tower protocols, Guild boards
        string resolution;  // e.g. Traditions preserved, Guardianship ensured, Neglect resolved
        uint256 timestamp;
    }

    GuildRecord[] public records;

    event GuildLogged(string principle, string dilemma, string safeguard, string resolution, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logGuild(
        string memory principle,
        string memory dilemma,
        string memory safeguard,
        string memory resolution
    ) public onlyChief {
        records.push(GuildRecord(principle, dilemma, safeguard, resolution, block.timestamp));
        emit GuildLogged(principle, dilemma, safeguard, resolution, block.timestamp);
    }

    function getGuild(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid guild index");
        GuildRecord memory gr = records[index];
        return (gr.principle, gr.dilemma, gr.safeguard, gr.resolution, gr.timestamp);
    }
}
