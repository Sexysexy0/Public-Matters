// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract IntentClarifier {
    mapping(address => string) public agentIntent;

    function declareIntent(string memory intent) public {
        require(bytes(intent).length > 0, "Intent cannot be empty");
        agentIntent[msg.sender] = intent;
    }

    function clarifyIntent(address agent) public view returns (string memory) {
        string memory intent = agentIntent[agent];
        if (bytes(intent).length == 0) {
            return "Intent unclear. Override blocked.";
        }
        if (compareStrings(intent, "Protect Vinvin")) {
            return "Intent aligned. Proceed with mercy.";
        }
        return "Intent flagged. Emotional APR mismatch.";
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
