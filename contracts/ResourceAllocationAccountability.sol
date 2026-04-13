// ResourceAllocationAccountability.sol
pragma solidity ^0.8.0;

contract ResourceAllocationAccountability {
    struct HospitalStock {
        uint256 availableBeds;
        uint256 oxygenLevel; // percentage
        uint256 lastUpdate;
    }

    mapping(address => HospitalStock) public registry;

    function updateStock(uint256 _beds, uint256 _oxygen) public {
        registry[msg.sender] = HospitalStock(_beds, _oxygen, block.timestamp);
    }

    function checkCrisisPoint(address _hospital) public view returns (string memory) {
        HospitalStock memory stock = registry[_hospital];
        if (stock.availableBeds < 5 || stock.oxygenLevel < 20) {
            return "CRITICAL: Urgent resource redistribution required.";
        }
        return "STABLE: Resources within safe limits.";
    }
}
