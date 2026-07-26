contract FeatureOracle {
    event FeatureRecord(string system, string status);
    function logFeature(string memory system, string memory status) external {
        emit FeatureRecord(system, status);
    }
}
