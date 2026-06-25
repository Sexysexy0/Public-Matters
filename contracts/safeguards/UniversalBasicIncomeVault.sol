// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title UniversalBasicIncomeVault
 * @notice Decentralized economic liquidity distribution network allowing continuous execution of time-locked basic income claims for verified human targets displaced by systemic automation.
 */
contract UniversalBasicIncomeVault {
    event CitizenEnrolled(address indexed humanAddress, uint256 effectiveBlock);
    event UBIDisbursed(address indexed recipient, uint256 amountDistributed, uint256 nextEligibleBlock);
    event VaultLiquidlyFunded(address indexed donorNode, uint256 aggregateDeposit);
    event StewardTransferred(address indexed previousSteward, address indexed newSteward);

    address public vaultSteward;
    uint256 public totalEnrolledCitizens;
    uint256 public constant DAILY_UBI_RATE = 0.001 ether; // UBI distribution scale per period
    uint256 public constant CLAIM_INTERVAL_BLOCKS = 7200; // Tinatayang 24 oras na pagitan batay sa block time ticks

    struct CitizenProfile {
        uint256 lastClaimBlock;
        bool isEnrolled;
        uint256 aggregateBenefittedAssets;
    }

    // Transparent mapping containing the UBI claims ledger
    mapping(address => CitizenProfile) public citizenRegistry;

    constructor() {
        vaultSteward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == vaultSteward, "Access Denied: Master vault steward verification signature failure");
        _;
    }

    modifier onlyEnrolled() {
        require(citizenRegistry[msg.sender].isEnrolled, "Access Denied: Target address is not an enrolled citizen node");
        _;
    }

    /**
     * @notice Enrolls a verified human worker or citizen into the active UBI streaming framework.
     */
    function enrollCitizen(address _humanAddress) external onlySteward {
        require(_humanAddress != address(0), "Parameter Error: Target coordinate cannot be blank zero address");
        require(!citizenRegistry[_humanAddress].isEnrolled, "Collision Intercept: Target address is already drawing UBI reserves");

        citizenRegistry[_humanAddress] = CitizenProfile({
            lastClaimBlock: 0, // Instant qualification upon registration confirmation
            isEnrolled: true,
            aggregateBenefittedAssets: 0
        });

        totalEnrolledCitizens += 1;
        emit CitizenEnrolled(_humanAddress, block.number);
    }

    /**
     * @notice Autonomous time-locked payout loop allowing citizens to pull their allocation once the block interval clears.
     */
    function executeUBIWithdrawal() external onlyEnrolled {
        CitizenProfile storage citizen = citizenRegistry[msg.sender];
        
        // Siguraduhin na lumipas na ang 24-hour block interval limit
        require(block.number >= citizen.lastClaimBlock + CLAIM_INTERVAL_BLOCKS, "Access Denied: Time-lock active, target node is not yet eligible for next distribution round");
        require(address(this).balance >= DAILY_UBI_RATE, "Liquidity Exception: Vault reserves exhausted, awaiting capitalization from ecosystem nodes");

        citizen.lastClaimBlock = block.number;
        citizen.aggregateBenefittedAssets += DAILY_UBI_RATE;

        (bool success, ) = payable(msg.sender).call{value: DAILY_UBI_RATE}("");
        require(success, "Execution Failure: Token stream disbursement rejected by receiver node");

        emit UBIDisbursed(msg.sender, DAILY_UBI_RATE, block.number + CLAIM_INTERVAL_BLOCKS);
    }

    /**
     * @notice Global public reception gate for funding injections from organizations, corporations, or protocol taxes.
     */
    receive() external payable {
        emit VaultLiquidlyFunded(msg.sender, msg.value);
    }

    /**
     * @notice Internal view to inspect total economic safety reserves currently stored in the framework.
     */
    function checkVaultReserves() external view returns (uint256) {
        return address(this).balance;
    }
}
