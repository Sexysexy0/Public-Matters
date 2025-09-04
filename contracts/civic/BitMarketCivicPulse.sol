// SPDX-License-Identifier: Mythic-CivicPulse
pragma solidity ^0.8.19;

interface IAuditBlessingOracle {
    function getProfile(address bidder) external view returns (
        uint256 emotionalAPR,
        bool damayCompliant,
        string memory auditStatus,
        uint256 prophecyScore,
        bool eligible
    );
}

contract BitMarketCivicPulse {
    address public steward;
    IAuditBlessingOracle public oracle;

    event PulseBroadcasted(
        address indexed bidder,
        uint256 emotionalAPR,
        bool damayCompliant,
        string auditStatus,
        uint256 prophecyScore,
        bool eligible,
        uint256 timestamp
    );

    constructor(address _oracle) {
        steward = msg.sender;
        oracle = IAuditBlessingOracle(_oracle);
    }

    function broadcastPulse(address bidder) public {
        require(msg.sender == steward, "Only steward may broadcast.");

        (
            uint256 apr,
            bool damay,
            string memory status,
            uint256 score,
            bool eligible
        ) = oracle.getProfile(bidder);

        emit PulseBroadcasted(bidder, apr, damay, status, score, eligible, block.timestamp);
    }
}
