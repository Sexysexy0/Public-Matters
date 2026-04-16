pragma solidity ^0.8.0;

contract CommunityResilienceShield {
    event ResilienceAlert(string community, string issue);

    function checkThreat(string memory community, bool threatDetected) public {
        if (threatDetected) {
            emit ResilienceAlert(community, "Community resilience safeguard activated");
        }
    }
}
