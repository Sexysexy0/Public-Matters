// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignLaborProtocol {
    
    address public immutable rootAdmin;
    uint256 public constant REGULARIZATION_PERIOD = 180 days;
    
    // Ang Gobyerno / Admin Subsidy Pool para protektahan ang SMEs
    uint256 public wageSubsidyPool;

    enum WorkerStatus { PROBATIONARY, REGULARIZED }
    enum CompanyTier { MSME, MEGACORP }

    struct Worker {
        address wallet;
        uint256 startDate;
        WorkerStatus status;
        bool isActive;
    }

    struct Company {
        CompanyTier tier;
        uint256 registeredBalance;
        mapping(address => Worker) roster;
    }

    mapping(address => Company) public companies;
    
    // Live tracker ng presyo ng bilihin (Inflation)
    uint256 public dynamicLivingWage;

    event WorkerHired(address company, address worker, uint256 timestamp);
    event WorkerAutoRegularized(address company, address worker, uint256 timestamp);
    event WagePaid(address company, address worker, uint256 amount);
    event OracleWageAdjusted(uint256 oldWage, uint256 newWage, uint256 timestamp);

    constructor(uint256 _initialLivingWage) {
        rootAdmin = msg.sender;
        dynamicLivingWage = _initialLivingWage;
    }

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "System Access Denied. Root Admin only.");
        _;
    }

    /**
     * @dev Pondo para tulungan ang mga maliliit na negosyo (MSMEs).
     */
    function fundSubsidyPool() external payable onlyAdmin {
        wageSubsidyPool += msg.value;
    }

    /**
     * @dev Oracle Simulation: Kapag tumaas ang inflation, automatic tataas ang requirement.
     * Tatapusin nito ang walang kwentang debate sa kongreso/wage board.
     */
    function updateLivingWage(uint256 _newCostOfLiving) external onlyAdmin {
        emit OracleWageAdjusted(dynamicLivingWage, _newCostOfLiving, block.timestamp);
        dynamicLivingWage = _newCostOfLiving;
    }

    /**
     * @dev Anti-Endo Protocol: Walang HR ang makakapigil nito.
     * Kapag nag-check ang system at lampas na sa 6 months, automatic REGULAR.
     */
    function checkAndRegularize(address _company, address _worker) internal {
        Worker storage w = companies[_company].roster[_worker];
        
        if (w.status == WorkerStatus.PROBATIONARY && block.timestamp >= w.startDate + REGULARIZATION_PERIOD) {
            w.status = WorkerStatus.REGULARIZED;
            emit WorkerAutoRegularized(_company, _worker, block.timestamp);
        }
    }

    /**
     * @dev Ang mismong pagpapasahod. 
     * Automatic nitong iche-check ang "Endo" status at kukunin ang tamang pondo (kung MSME o MegaCorp).
     */
    function executePayroll(address _company, address _worker) external {
        Worker storage w = companies[_company].roster[_worker];
        require(w.isActive, "Worker is not active.");

        // Step 1: I-check kung dapat na ba siyang ma-regular.
        checkAndRegularize(_company, _worker);

        uint256 wageToPay = dynamicLivingWage;
        uint256 companyPayment = wageToPay;
        uint256 subsidy = 0;

        // Step 2: MSME Shield Logic
        // Kung malaking kumpanya, babayaran nila ng buo ang dynamicLivingWage.
        // Kung MSME, babayaran lang nila kung ano ang kaya nila, at sasalo ang Gobyerno sa kulang.
        if (companies[_company].tier == CompanyTier.MSME) {
            // Halimbawa: 70% lang ang kaya ng MSME, 30% ay galing sa Wage Subsidy Pool
            companyPayment = (wageToPay * 70) / 100;
            subsidy = wageToPay - companyPayment;
            
            require(wageSubsidyPool >= subsidy, "Subsidy pool dry.");
            wageSubsidyPool -= subsidy;
        }

        // Sapilitang pag-transfer ng pondo mula sa Company papunta sa Worker.
        // Walang TRO ang makakapigil sa smart contract execution.
        // (In a real deployment, logic using ERC20 transfers via allowances would occur here)
        
        emit WagePaid(_company, _worker, wageToPay);
    }
}
