// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DueProcessCodex {
    enum Status { None, Pending, Verified, Dismissed }

    struct Accusation {
        uint256 id;
        address accuser;
        address accused;
        string details;
        uint256 timestamp;
        bool verified;
        Status status;
    }

    uint256 public accusationCount;
    mapping(uint256 => Accusation) public accusations;
    address public owner;

    event AccusationFiled(uint256 indexed id, address indexed accuser, address indexed accused, string details);
    event AccusationVerified(uint256 indexed id, address verifier);
    event AccusationDismissed(uint256 indexed id, string reason);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier requireDetails(string memory details) {
        require(bytes(details).length > 20, "Details too vague");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function fileAccusation(address accused, string calldata details) 
        external 
        requireDetails(details) 
    {
        require(accused != address(0), "Invalid accusation");
        require(accused != msg.sender, "Cannot accuse self");

        accusationCount++;
        accusations[accusationCount] = Accusation({
            id: accusationCount,
            accuser: msg.sender,
            accused: accused,
            details: details,
            timestamp: block.timestamp,
            verified: false,
            status: Status.Pending
        });

        emit AccusationFiled(accusationCount, msg.sender, accused, details);
    }

    function verifyAccusation(uint256 id) external onlyOwner {
        require(id > 0 && id <= accusationCount, "No such accusation");
        require(accusations[id].status == Status.Pending, "Accusation not pending");

        accusations[id].verified = true;
        accusations[id].status = Status.Verified;
        emit AccusationVerified(id, msg.sender);
    }

    function dismissAccusation(uint256 id, string calldata reason) external {
        require(id > 0 && id <= accusationCount, "No such accusation");
        Accusation storage a = accusations[id];
        require(msg.sender == owner || msg.sender == a.accuser, "Not authorized to dismiss");
        require(a.status == Status.Pending, "Accusation not pending");

        a.status = Status.Dismissed;
        a.verified = false;
        emit AccusationDismissed(id, reason);
    }
}
