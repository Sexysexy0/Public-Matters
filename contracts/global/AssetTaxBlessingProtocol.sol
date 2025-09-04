// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract AssetTaxBlessingProtocol {
    address public steward;

    struct VendorAssets {
        uint256 landValue;
        uint256 equipmentValue;
        uint256 inventoryValue;
        uint8 emotionalAPR;
        bool exempted;
    }

    mapping(address => VendorAssets) public assetLedger;
    mapping(address => uint256) public assetTaxDue;

    event AssetDeclared(address indexed vendor, uint256 totalAssets, uint256 taxDue);
    event ExemptionGranted(address indexed vendor);
    event APRUpdated(address indexed vendor, uint8 newAPR);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: steward only");
        _;
    }

    function declareAssets(
        address _vendor,
        uint256 _land,
        uint256 _equipment,
        uint256 _inventory,
        uint8 _apr
    ) external onlySteward {
        require(_apr <= 100, "Invalid APR score");
        assetLedger[_vendor] = VendorAssets(_land, _equipment, _inventory, _apr, false);
        uint256 totalAssets = _land + _equipment + _inventory;
        uint256 tax = calculateAssetTax(totalAssets, _apr);
        assetTaxDue[_vendor] = tax;
        emit AssetDeclared(_vendor, totalAssets, tax);
    }

    function calculateAssetTax(uint256 _totalAssets, uint8 _apr) public pure returns (uint256) {
        if (_apr >= 90) return (_totalAssets * 1) / 100; // Mercy tier
        if (_apr >= 70) return (_totalAssets * 3) / 100; // Standard tier
        return (_totalAssets * 5) / 100; // Prosperity tier
    }

    function grantExemption(address _vendor) external onlySteward {
        assetLedger[_vendor].exempted = true;
        assetTaxDue[_vendor] = 0;
        emit ExemptionGranted(_vendor);
    }

    function updateAPR(address _vendor, uint8 _newAPR) external onlySteward {
        require(_newAPR <= 100, "Invalid APR score");
        assetLedger[_vendor].emotionalAPR = _newAPR;
        uint256 totalAssets = assetLedger[_vendor].landValue +
                              assetLedger[_vendor].equipmentValue +
                              assetLedger[_vendor].inventoryValue;
        assetTaxDue[_vendor] = calculateAssetTax(totalAssets, _newAPR);
        emit APRUpdated(_vendor, _newAPR);
    }

    function getTaxDue(address _vendor) external view returns (uint256) {
        if (assetLedger[_vendor].exempted) return 0;
        return assetTaxDue[_vendor];
    }
}
