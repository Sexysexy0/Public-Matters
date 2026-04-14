// TransparencyHeatmap.sol
// Logic: Visualizing the Theft
pragma solidity ^0.8.0;

contract TransparencyHeatmap {
    enum IntegrityStatus { GREEN, YELLOW, RED }

    struct District {
        string location;
        uint256 floodBudget;
        uint256 actualInfrastructure;
        IntegrityStatus status;
    }

    function updateDistrictStatus(string memory _loc, uint256 _budget, uint256 _actual) public pure returns (IntegrityStatus) {
        // If Actual Infra is less than 50% of Budget = RED (Corruption detected).
        if (_actual < (_budget / 2)) {
            return IntegrityStatus.RED;
        }
        return IntegrityStatus.GREEN;
    }
}
