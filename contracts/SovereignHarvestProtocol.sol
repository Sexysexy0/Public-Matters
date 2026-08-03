// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignHarvestProtocol {
    
    address public immutable solicitorGeneral;
    
    struct Farmer {
        bool isVerified;
        string location; // e.g., "Malolos, Central Luzon"
        uint256 totalYield;
    }

    struct CropListing {
        uint256 pricePerKilo;
        uint256 availableKilos;
        address farmerWallet;
        bool isActive;
    }

    mapping(address => Farmer) public registeredFarmers;
    mapping(uint256 => CropListing) public cropMarket;
    
    uint256 public nextListingId;
    
    // Anti-Hoarding Mechanism: Maximum kilos a single entity can buy to prevent cartel hoarding
    uint256 public maxPurchaseLimit = 500; 

    event FarmerRegistered(address farmer, string location);
    event CropListed(uint256 listingId, address farmer, uint256 price, uint256 amount);
    event DirectPurchase(uint256 listingId, address buyer, uint256 kilosBought, uint256 amountPaid);
    event CartelBlocked(address attemptedBuyer, uint256 attemptedAmount);

    constructor() {
        solicitorGeneral = msg.sender; // Ang Root Executor
    }

    modifier onlyOSG() {
        require(msg.sender == solicitorGeneral, "Execution Denied: OSG clearance required.");
        _;
    }

    /**
     * @dev Nirerehistro ng OSG ang mga totoong magsasaka para hindi makapasok ang mga peke o dummy ng middlemen.
     */
    function verifyFarmer(address _farmerWallet, string memory _location) external onlyOSG {
        registeredFarmers[_farmerWallet] = Farmer({
            isVerified: true,
            location: _location,
            totalYield: 0
        });
        emit FarmerRegistered(_farmerWallet, _location);
    }

    /**
     * @dev Direktang naglilista ng presyo ang magsasaka, walang patong ng middleman.
     */
    function listHarvest(uint256 _pricePerKilo, uint256 _availableKilos) external {
        require(registeredFarmers[msg.sender].isVerified, "Access Denied: Only verified producers can list.");
        
        cropMarket[nextListingId] = CropListing({
            pricePerKilo: _pricePerKilo,
            availableKilos: _availableKilos,
            farmerWallet: msg.sender,
            isActive: true
        });
        
        emit CropListed(nextListingId, msg.sender, _pricePerKilo, _availableKilos);
        nextListingId++;
    }

    /**
     * @dev Ang Smart Contract na papatay sa mga Hoarders at Cartel.
     * Bibili direkta ang consumer, at ibablock ng system ang bibili ng sobra-sobra para itago.
     */
    function buyDirect(uint256 _listingId, uint256 _kilosToBuy) external payable {
        CropListing storage listing = cropMarket[_listingId];
        require(listing.isActive, "Listing is closed.");
        require(listing.availableKilos >= _kilosToBuy, "Not enough supply.");
        
        // Anti-Cartel Protocol Trigger
        if (_kilosToBuy > maxPurchaseLimit) {
            emit CartelBlocked(msg.sender, _kilosToBuy);
            revert("Transaction Blocked: Anti-Hoarding limit exceeded.");
        }

        uint256 totalCost = listing.pricePerKilo * _kilosToBuy;
        require(msg.value == totalCost, "Incorrect payment amount.");

        // Direktang pumasok ang pera sa wallet ng magsasaka
        listing.availableKilos -= _kilosToBuy;
        if (listing.availableKilos == 0) {
            listing.isActive = false;
        }

        payable(listing.farmerWallet).transfer(msg.value);
        emit DirectPurchase(_listingId, msg.sender, _kilosToBuy, totalCost);
    }
}
