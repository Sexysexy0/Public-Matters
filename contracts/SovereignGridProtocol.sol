// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignGridProtocol {
    
    address public immutable solicitorGeneral;
    
    struct MicroGridNode {
        bool isActive;
        uint256 excessKWh;      // Sobrang kuryente mula sa solar/wind ng komunidad
        uint256 pricePerKWh;    // Presyong idinikta ng komunidad (mas mura kaysa sa MegaCorp)
    }

    // Mapping ng mga bahay o barangay na may sariling power generation
    mapping(address => MicroGridNode) public communityGrids;
    
    // Pondo mula sa penalties ng mga monopolyo para pambili ng solar panels ng mahihirap
    uint256 public renewableSubsidyPool;

    event NodeRegistered(address communityNode);
    event EnergyListed(address node, uint256 kwhAmount, uint256 price);
    event P2PEnergyBought(address buyer, address seller, uint256 kwhBought, uint256 amountPaid);
    event MonopolyPenalized(string corpName, uint256 fineAmount);

    constructor() {
        solicitorGeneral = msg.sender; // Ang OSG bilang Chief Grid Overseer
    }

    modifier onlyOSG() {
        require(msg.sender == solicitorGeneral, "Execution Denied: Root Admin/OSG only.");
        _;
    }

    /**
     * @dev Step 1: I-register ang isang komunidad (hal. isang barangay sa Malolos) bilang Micro-Grid.
     * Imbes na umasa sa malaking korporasyon, sila na ang sarili nilang power plant.
     */
    function registerMicroGrid(address _communityWallet) external onlyOSG {
        communityGrids[_communityWallet] = MicroGridNode({
            isActive: true,
            excessKWh: 0,
            pricePerKWh: 0
        });
        emit NodeRegistered(_communityWallet);
    }

    /**
     * @dev Step 2: Kapag may sobrang na-generate na kuryente ang solar panels ng komunidad,
     * pwede nilang ibenta ito nang direkta sa network.
     */
    function listExcessEnergy(uint256 _kwhAmount, uint256 _pricePerKWh) external {
        require(communityGrids[msg.sender].isActive, "Not a registered Micro-Grid Node.");
        
        communityGrids[msg.sender].excessKWh = _kwhAmount;
        communityGrids[msg.sender].pricePerKWh = _pricePerKWh;
        
        emit EnergyListed(msg.sender, _kwhAmount, _pricePerKWh);
    }

    /**
     * @dev Step 3: P2P Energy Trading. Kung brownout ang bahay mo, hindi ka na tatawag sa MegaCorp.
     * Bibilhin ng smart meter mo ang sobrang kuryente ng kapitbahay mo gamit ang smart contract.
     */
    function buyEnergyP2P(address _sellerNode, uint256 _kwhToBuy) external payable {
        MicroGridNode storage seller = communityGrids[_sellerNode];
        
        require(seller.isActive, "Seller is not an active node.");
        require(seller.excessKWh >= _kwhToBuy, "Not enough excess energy to sell.");
        
        uint256 totalCost = seller.pricePerKWh * _kwhToBuy;
        require(msg.value == totalCost, "Incorrect payment amount.");

        // Ibabawas ang kuryente sa seller at ibibigay ang bayad sa kanila nang walang middleman
        seller.excessKWh -= _kwhToBuy;
        payable(_sellerNode).transfer(msg.value);
        
        emit P2PEnergyBought(msg.sender, _sellerNode, _kwhToBuy, totalCost);
    }

    /**
     * @dev Step 4: The OSG Anti-Monopoly Guillotine.
     * Kapag nag-declare ng peke at manipuladong "Red Alert" ang mga malalaking planta para magtaas ng presyo,
     * i-e-execute ng OSG ang instant penalty. Ang fine ay mapupunta sa Subsidy Pool para ibili ng solar panels ng masa.
     */
    function penalizeMegaCorp(string memory _corpName) external payable onlyOSG {
        require(msg.value > 0, "Penalty must include seized funds.");
        renewableSubsidyPool += msg.value;
        emit MonopolyPenalized(_corpName, msg.value);
    }
}
