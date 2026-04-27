contract ExplorationExpansionShield {
    event ExpansionSeal(string region, string feature);
    function logExpansion(string memory region, string memory feature) external {
        emit ExpansionSeal(region, feature);
    }
}
