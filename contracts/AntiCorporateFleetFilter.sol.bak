// AntiCorporateFleetFilter.sol
pragma solidity ^0.8.0;

contract AntiCorporateFleetFilter {
    uint256 public constant MAX_UNITS_PER_PERSON = 2;
    mapping(address => uint256) public unitsOwned;

    function checkOwnershipLimit(address _owner) public view returns (bool) {
        // Preventing the rise of "Digital Landlords."
        // Ensuring the tools of production stay in the hands of the workers.
        return unitsOwned[_owner] <= MAX_UNITS_PER_PERSON;
    }
}
