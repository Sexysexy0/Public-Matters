// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DataSovereigntyOracle
/// @notice Safeguard contract to enforce cross-border data transfer tracking, ensure data localization compliance, and protect national data sovereignty
contract DataSovereigntyOracle {
    event DataFlowAudited(bytes32 indexed transactionHash, address indexed dataExporter, string destinationCountry, bool indexed isApproved);
    event LocalizationRuleEnforced(string jurisdiction, bytes32 regulatoryHash, bool strictModeActive);
    event SovereigntyBreachFlagged(address indexed exporter, string reason);
    event ClearanceAuthorityUpdated(address indexed previousAuthority, address indexed newAuthority);

    address public clearanceAuthority;
    bool public strictSovereigntyMode;

    struct DataTransferRecord {
        bool isLogged;
        bool cryptographicClearance;
        string dataCategory; // e.g., "Sensitive Sovereign Data", "Public Information"
        uint256 timestamp;
    }

    // Mapping from transaction hash to its sovereignty ledger record
    mapping(bytes32 => DataTransferRecord) public transferLedger;
    // Mapping to track verified cross-border data nodes
    mapping(address => bool) public verifiedExternalNodes;

    constructor() {
        clearanceAuthority = msg.sender;
        strictSovereigntyMode = true; // Default to proactive, strict national data localization
    }

    modifier onlyAuthority() {
        require(msg.sender == clearanceAuthority, "Unauthorized: Clearance Authority credential required");
        _;
    }

    /// @notice Register and whitelist a trusted external cross-border data hub
    function updateExternalNode(address _node, bool _status) external onlyAuthority {
        require(_node != address(0), "Invalid node coordinates");
        verifiedExternalNodes[_node] = _status;
    }

    /// @notice Audit and push real-time cross-border data transfer tokens
    /// @param _txHash Cryptographic hash of the data packet or transfer transaction
    /// @param _exporter The address of the entity exporting the data
    /// @param _destination The target country or framework receiving the information
    /// @param _category Description of the sovereign data being routed
    function pushDataTransferLog(
        bytes32 _txHash,
        address _exporter,
        string memory _destination,
        string memory _category
    ) external onlyAuthority {
        require(_txHash != bytes32(0), "Invalid transaction token");
        require(_exporter != address(0), "Invalid exporter address metrics");

        bool approved = true;

        if (strictSovereigntyMode && keccak256(bytes(_category)) == keccak256(bytes("Sensitive Sovereign Data"))) {
            // Strict localization rule: unverified destination nodes spark automated block flags
            if (!verifiedExternalNodes[msg.sender]) {
                approved = false;
                emit SovereigntyBreachFlagged(_exporter, "Breach: Cross-border transfer of Sensitive Sovereign Data to unverified node blocked");
            }
        }

        transferLedger[_txHash] = DataTransferRecord({
            isLogged: true,
            cryptographicClearance: approved,
            dataCategory: _category,
            timestamp: block.timestamp
        });

        emit DataFlowAudited(_txHash, _exporter, _destination, approved);
    }

    /// @notice Real-time automated verification for network data transfers and cross-border routing
    function verifyTransferClearance(bytes32 _txHash) external view returns (bool) {
        DataTransferRecord memory record = transferLedger[_txHash];
        if (!record.isLogged || !record.cryptographicClearance) {
            return false;
        }
        return true;
    }

    /// @notice Toggle strict data localization modes in response to evolving geopolitical or infrastructure risks
    function toggleSovereigntyMode(bool _strictMode, bytes32 _regulatoryHash) external onlyAuthority {
        strictSovereigntyMode = _strictMode;
        emit LocalizationRuleEnforced("PH- Hurisdiksyon", _regulatoryHash, _strictMode);
    }

    /// @notice Upgrade or migrate the Clearance Authority layer
    function transferClearanceAuthority(address _newAuthority) external onlyAuthority {
        require(_newAuthority != address(0), "Invalid authority coordinates");
        emit ClearanceAuthorityUpdated(clearanceAuthority, _newAuthority);
        clearanceAuthority = _newAuthority;
    }
}
