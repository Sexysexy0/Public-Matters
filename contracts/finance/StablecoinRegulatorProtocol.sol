// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title StablecoinRegulatorProtocol
/// @notice Registers banks as stablecoin stewards, verifies reserve integrity, and emits breach-tier audit events
/// @dev Anchors civic trust, emotional consequence tagging, and synthetic corridor oversight

contract StablecoinRegulatorProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum ReserveStatus {
        Verified,
        BreachDetected,
        Unverified
    }

    struct Bank {
        string name;
        string jurisdiction;
        bool active;
        uint256 registeredAt;
    }

    struct Stablecoin {
        uint256 id;
        address bank;
        string asset; // e.g., "USDC", "DAI", "PHX"
        uint256 reserveAmount;
        ReserveStatus status;
        string breachTier;
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextStablecoinId = 1;
    mapping(address => Bank) public bankRegistry;
    mapping(uint256 => Stablecoin) public stablecoinRegistry;
    mapping(address => uint256[]) public bankStablecoins;

    event AuditorSet(address indexed account, bool status);
    event BankRegistered(address indexed bank, string name, string jurisdiction);
    event StablecoinFiled(uint256 indexed id, address indexed bank, string asset);
    event ReserveStatusUpdated(uint256 indexed id, ReserveStatus status, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function registerBank(address bankAddr, string calldata name, string calldata jurisdiction) external onlyAuditor {
        require(!bankRegistry[bankAddr].active, "Bank already registered");
        bankRegistry[bankAddr] = Bank({
            name: name,
            jurisdiction: jurisdiction,
            active: true,
            registeredAt: block.timestamp
        });
        emit BankRegistered(bankAddr, name, jurisdiction);
    }

    function fileStablecoin(
        address bankAddr,
        string calldata asset,
        uint256 reserveAmount
    ) external onlyAuditor returns (uint256 id) {
        require(bankRegistry[bankAddr].active, "Bank not verified");
        id = nextStablecoinId++;
        stablecoinRegistry[id] = Stablecoin({
            id: id,
            bank: bankAddr,
            asset: asset,
            reserveAmount: reserveAmount,
            status: ReserveStatus.Unverified,
            breachTier: "",
            emotionalTag: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        bankStablecoins[bankAddr].push(id);
        emit StablecoinFiled(id, bankAddr, asset);
    }

    function updateReserveStatus(
        uint256 id,
        ReserveStatus status,
        string calldata breachTier,
        string calldata emotionalTag
    ) external onlyAuditor {
        Stablecoin storage sc = stablecoinRegistry[id];
        require(sc.id != 0, "Stablecoin not found");
        sc.status = status;
        sc.breachTier = breachTier;
        sc.emotionalTag = emotionalTag;
        sc.updatedAt = block.timestamp;
        emit ReserveStatusUpdated(id, status, breachTier, emotionalTag);
    }

    function getBank(address bankAddr) external view returns (Bank memory) {
        return bankRegistry[bankAddr];
    }

    function getStablecoin(uint256 id) external view returns (Stablecoin memory) {
        return stablecoinRegistry[id];
    }

    function listBankStablecoins(address bankAddr) external view returns (uint256[] memory) {
        return bankStablecoins[bankAddr];
    }
}
