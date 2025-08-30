contract PlanetaryDefenseSync {
    address[] public syncedSanctums;
    event SanctumSynced(address sanctum, string region);

    function syncSanctum(address sanctum, string memory region) public {
        syncedSanctums.push(sanctum);
        emit SanctumSynced(sanctum, region);
    }

    function getSyncedSanctums() public view returns (address[] memory) {
        return syncedSanctums;
    }
}
