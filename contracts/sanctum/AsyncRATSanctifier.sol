// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AsyncRATSanctifier {
    struct RATInvocation {
        string originHost;
        string payloadSummary;
        uint256 timestamp;
        bool fileless;
        string c2Address;
        bool verified;
    }

    mapping(uint256 => RATInvocation) public ratLedger;
    uint256 public ratCount;

    event RATSanctified(uint256 id, string originHost, string c2Address);

    function logInvocation(
        string memory originHost,
        string memory payloadSummary,
        uint256 timestamp,
        bool fileless,
        string memory c2Address
    ) public {
        ratLedger[ratCount] = RATInvocation(
            originHost,
            payloadSummary,
            timestamp,
            fileless,
            c2Address,
            false
        );
        emit RATSanctified(ratCount, originHost, c2Address);
        ratCount++;
    }

    function verifyInvocation(uint256 id) public {
        ratLedger[id].verified = true;
    }

    function getInvocation(uint256 id) public view returns (RATInvocation memory) {
        return ratLedger[id];
    }
}
