// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DueProcessCodex {
    struct Accusation {
        uint256 id;
        address accuser;
        address accused;
        string details; // must include who/when/where
        uint256 timestamp;
        bool verified;
    }

    uint256 public accusationCount;
    mapping(uint256 => Accusation) public accusations;

    event AccusationFiled(uint256 id, address accuser, address accused, string details);
    event AccusationVerified(uint256 id, address verifier);
    event AccusationDismissed(uint256 id, string reason);

    modifier requireDetails(string memory details) {
        require(bytes(details).length > 20, "Details too vague");
        _;
    }

    function fileAccusation(address accused, string calldata details)
        external
        requireDetails(details)
    {
        accusationCount++;
        accusations[accusationCount] = Accusation({
            id: accusationCount,
            accuser: msg.sender,
            accused: accused,
            details: details,
            timestamp: block.timestamp,
            verified: false
        });
        emit AccusationFiled(accusationCount, msg.sender, accused, details);
    }

    function verifyAccusation(uint256 id) external {
        require(accusations[id].id != 0, "No such accusation");
        accusations[id].verified = true;
        emit AccusationVerified(id, msg.sender);
    }

    function dismissAccusation(uint256 id, string calldata reason) external {
        require(accusations[id].id != 0, "No such accusation");
        delete accusations[id];
        emit AccusationDismissed(id, reason);
    }
}
