// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSAuthorityCovenant
// Purpose: Encodes systemic authority chain, decision rights, and validation safeguards
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSAuthorityCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Authority {
        string role;          // Chief, Trustee, Operator, Proxy
        string decisionRight; // Scope of authority
        string safeguard;     // Validation, accountability, clarity
        uint256 timestamp;
    }

    Authority[] public authorities;

    event AuthorityLogged(string role, string decisionRight, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logAuthority(string memory role, string memory decisionRight, string memory safeguard) public onlyChief {
        authorities.push(Authority(role, decisionRight, safeguard, block.timestamp));
        covenantCount++;
        emit AuthorityLogged(role, decisionRight, safeguard, block.timestamp);
    }

    function getAuthority(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < authorities.length, "Invalid authority index");
        Authority memory a = authorities[index];
        return (a.role, a.decisionRight, a.safeguard, a.timestamp);
    }
}
