// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityResonanceVault {
    struct Request {
        address fan;
        string title;
        string context;
        uint256 timestamp;
        bool safeguarded;
    }

    Request[] public requests;

    event RequestLogged(address indexed fan, string title, string context);
    event RequestSafeguarded(uint256 indexed id, address verifier);

    function logRequest(string memory _title, string memory _context) public {
        requests.push(Request(msg.sender, _title, _context, block.timestamp, false));
        emit RequestLogged(msg.sender, _title, _context);
    }

    function safeguardRequest(uint256 _id) public {
        require(_id < requests.length, "Invalid ID");
        requests[_id].safeguarded = true;
        emit RequestSafeguarded(_id, msg.sender);
    }

    function getRequest(uint256 _id) public view returns (Request memory) {
        require(_id < requests.length, "Invalid ID");
        return requests[_id];
    }

    function totalRequests() public view returns (uint256) {
        return requests.length;
    }
}
