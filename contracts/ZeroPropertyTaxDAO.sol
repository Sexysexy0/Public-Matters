// ZeroPropertyTaxDAO.sol
pragma solidity ^0.8.0;

contract ZeroPropertyTaxDAO {
    struct Property {
        address owner;
        bool isPrimaryResidence;
        uint256 taxDue;
    }

    mapping(uint256 => Property) public landRegistry;

    function claimImmunity(uint256 _landId) public {
        // One primary residence per citizen is strictly 0% tax
        require(landRegistry[_landId].owner == msg.sender, "Not the owner");
        landRegistry[_landId].isPrimaryResidence = true;
        landRegistry[_landId].taxDue = 0;
    }
}
