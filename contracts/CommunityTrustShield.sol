pragma solidity ^0.8.0;

contract CommunityTrustShield {
    event TrustAlert(string issue, string detail);

    function detectTrustRisk(string memory issue, bool risk) public {
        if (risk) {
            emit TrustAlert(issue, "Trust erosion detected – safeguard required");
        }
    }
}
