// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AncestralMarketSupport {
    struct VendorContract {
        string tribe;
        string product; // e.g. "Rattan", "Banig", "Coffee", "Herbal Oil"
        uint256 quantity;
        uint256 pricePerUnit;
        string buyerAgency; // e.g. "DA", "DTI", "LGU", "NCIP"
        string emotionalTag; // e.g. "AncestorGlow", "DamayClause", "BlessedFlow"
        uint256 timestamp;
    }

    VendorContract[] public contracts;

    event ContractLogged(string tribe, string product, uint256 quantity, string buyerAgency, string emotionalTag);

    function logContract(
        string memory _tribe,
        string memory _product,
        uint256 _quantity,
        uint256 _pricePerUnit,
        string memory _buyerAgency,
        string memory _emotionalTag
    ) public {
        contracts.push(VendorContract(_tribe, _product, _quantity, _pricePerUnit, _buyerAgency, _emotionalTag, block.timestamp));
        emit ContractLogged(_tribe, _product, _quantity, _buyerAgency, _emotionalTag);
    }

    function getContract(uint256 index) public view returns (VendorContract memory) {
        return contracts[index];
    }

    function totalContracts() public view returns (uint256) {
        return contracts.length;
    }
}
