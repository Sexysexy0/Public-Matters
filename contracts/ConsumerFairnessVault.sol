// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConsumerFairnessVault {
    struct ConsumerFairness {
        address steward;
        string context;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    ConsumerFairness[] public fairnessVault;

    event ConsumerFairnessLogged(address indexed steward, string context, string safeguard);
    event ConsumerFairnessSafeguarded(uint256 indexed id, address verifier);

    function logConsumerFairness(string memory _context, string memory _safeguard) public {
        fairnessVault.push(ConsumerFairness(msg.sender, _context, _safeguard, block.timestamp, false));
        emit ConsumerFairnessLogged(msg.sender, _context, _safeguard);
    }

    function safeguardConsumerFairness(uint256 _id) public {
        require(_id < fairnessVault.length, "Invalid ID");
        fairnessVault[_id].safeguarded = true;
        emit ConsumerFairnessSafeguarded(_id, msg.sender);
    }

    function getConsumerFairness(uint256 _id) public view returns (ConsumerFairness memory) {
        require(_id < fairnessVault.length, "Invalid ID");
        return fairnessVault[_id];
    }

    function totalFairnessLogs() public view returns (uint256) {
        return fairnessVault.length;
    }
}
