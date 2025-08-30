contract KinderFallbackSanctumPlan {
    struct Fallback {
        string resource;
        bool isActive;
    }

    mapping(address => Fallback[]) public sanctumFallbacks;

    function activateFallback(address user, string memory resource) public {
        sanctumFallbacks[user].push(Fallback(resource, true));
    }

    function getFallbacks(address user) public view returns (Fallback[] memory) {
        return sanctumFallbacks[user];
    }
}
