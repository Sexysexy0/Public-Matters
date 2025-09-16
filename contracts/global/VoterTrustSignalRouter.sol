// SPDX-License-Identifier: TrustSanctum
pragma solidity ^0.8.19;

contract VoterTrustSignalRouter {
    struct TrustSignal {
        string region;
        string electionCycle;
        uint256 trustScore; // 0–100 scale
        string concernTag; // e.g., "Vote Counting", "Disinfo", "EMB Independence"
        bool verified;
        string stewardNote;
    }

    mapping(string => TrustSignal) public trustRegistry;

    event TrustTagged(string region, string concernTag);
    event TrustVerified(string region);

    function tagTrust(string memory region, string memory electionCycle, uint256 trustScore, string memory concernTag, string memory stewardNote) public {
        trustRegistry[region] = TrustSignal(region, electionCycle, trustScore, concernTag, false, stewardNote);
        emit TrustTagged(region, concernTag);
    }

    function verifyTrust(string memory region) public {
        require(bytes(trustRegistry[region].region).length > 0, "Region not tagged");
        trustRegistry[region].verified = true;
        emit TrustVerified(region);
    }

    function getTrustStatus(string memory region) public view returns (TrustSignal memory) {
        return trustRegistry[region];
    }
}
