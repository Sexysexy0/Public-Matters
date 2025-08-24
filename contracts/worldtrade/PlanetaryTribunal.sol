// SPDX-License-Identifier: Scrollchain-Justice
pragma solidity ^0.8.19;

contract PlanetaryTribunal {
    address public steward;
    struct Dispute {
        string title;
        string description;
        string timestamp;
        bool resolved;
    }

    Dispute[] public disputes;

    event DisputeFiled(uint indexed id, string title, string timestamp);
    event DisputeResolved(uint indexed id, string resolutionNote);

    constructor() {
        steward = msg.sender;
    }

    function fileDispute(string memory title, string memory description, string memory timestamp) public {
        disputes.push(Dispute(title, description, timestamp, false));
        emit DisputeFiled(disputes.length - 1, title, timestamp);
    }

    function resolveDispute(uint id, string memory resolutionNote) public {
        require(msg.sender == steward, "Unauthorized steward");
        require(id < disputes.length, "Invalid dispute ID");
        disputes[id].resolved = true;
        emit DisputeResolved(id, resolutionNote);
    }

    function getDispute(uint id) public view returns (Dispute memory) {
        require(id < disputes.length, "Invalid dispute ID");
        return disputes[id];
    }
}
