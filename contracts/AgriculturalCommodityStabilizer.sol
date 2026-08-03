// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AgriculturalCommodityStabilizer
 * @dev Direct Farmer Procurement, Fair Price Floor & Strategic Grain Reserve Ledger
 */
contract AgriculturalCommodityStabilizer {
    address public rootAdmin;
    uint256 public minFarmerFloorPrice; // Minimum price per kg guaranteed to farmers

    struct InventoryBatch {
        string commodityType; // e.g., "Palay / Rice Grade A"
        uint256 quantityKg;
        uint256 purchasePricePerKg;
        address farmerWallet;
        bool ReleasedToMarket;
    }

    mapping(uint256 => InventoryBatch) public reserves;
    mapping(address => bool) public verifiedFarmers;
    uint256 public batchCount;
    uint256 public totalReserveKg;

    event FarmerRegistered(address indexed farmer);
    event GrainProcured(uint256 indexed batchId, address indexed farmer, uint256 quantityKg, uint256 pricePerKg);
    event ReserveReleased(uint256 indexed batchId, uint256 quantityKg);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "ACS: Only Root Admin authorized");
        _;
    }

    constructor(uint256 _minFarmerFloorPrice) payable {
        rootAdmin = msg.sender;
        minFarmerFloorPrice = _minFarmerFloorPrice;
    }

    receive() external payable {}

    function registerFarmer(address _farmer) external onlyAdmin {
        verifiedFarmers[_farmer] = true;
        emit FarmerRegistered(_farmer);
    }

    function procureGrain(
        string memory _commodityType,
        uint256 _quantityKg,
        uint256 _pricePerKg
    ) external returns (uint256) {
        require(verifiedFarmers[msg.sender], "ACS: Only verified farmers allowed");
        require(_pricePerKg >= minFarmerFloorPrice, "ACS: Price below guaranteed floor limit");

        uint256 totalPayment = _quantityKg * _pricePerKg;
        require(address(this).balance >= totalPayment, "ACS: Insufficient procurement fund reserve");

        batchCount++;
        reserves[batchCount] = InventoryBatch({
            commodityType: _commodityType,
            quantityKg: _quantityKg,
            purchasePricePerKg: _pricePerKg,
            farmerWallet: msg.sender,
            ReleasedToMarket: false
        });

        totalReserveKg += _quantityKg;

        (bool success, ) = payable(msg.sender).call{value: totalPayment}("");
        require(success, "ACS: Payment to farmer failed");

        emit GrainProcured(batchCount, msg.sender, _quantityKg, _pricePerKg);
        return batchCount;
    }

    function releaseReserveForRelief(uint256 _batchId) external onlyAdmin {
        InventoryBatch storage batch = reserves[_batchId];
        require(!batch.ReleasedToMarket, "ACS: Batch already released");
        require(batch.quantityKg > 0, "ACS: Invalid batch quantity");

        batch.ReleasedToMarket = true;
        totalReserveKg -= batch.quantityKg;

        emit ReserveReleased(_batchId, batch.quantityKg);
    }
}
