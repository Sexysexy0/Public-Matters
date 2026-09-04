// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

/**
 * @title DredgingContractorRegistry
 * @author The Source
 * @notice Tracks every dredging contract in Pampanga—cost, duration, outcomes.
 * @dev Links to TrustScoreDAO for contractor reputation.
 */
contract DredgingContractorRegistry {
    address public admin;
    address public trustScoreDAO;
    bool public active;
    uint256 public contractCount;

    struct DredgingContract {
        uint256 id;
        string projectName;
        string location;
        address contractor;
        uint256 contractValue; // In wei
        uint256 startDate;
        uint256 endDate;
        uint256 actualCost;
        bool completed;
        bool successful; // Did it actually reduce flood risk?
        string notes;
        uint256 timestamp;
        string ipfsHash; // Link to documents
    }

    struct Contractor {
        address wallet;
        string name;
        uint256 totalContracts;
        uint256 totalValue;
        uint256 successfulContracts;
        uint256 failedContracts;
        uint256 reputationScore; // 0-100
        bool registered;
    }

    mapping(uint256 => DredgingContract) public contracts;
    mapping(address => Contractor) public contractors;
    mapping(address => bool) public isRegistrar;

    event ContractRegistered(uint256 indexed id, address contractor, uint256 value);
    event ContractCompleted(uint256 indexed id, bool successful);
    event ContractorRegistered(address indexed contractor, string name);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyRegistrar() {
        require(isRegistrar[msg.sender], "Not a registrar");
        _;
    }

    modifier whenActive() {
        require(active, "System paused");
        _;
    }

    constructor(address _trustScoreDAO) {
        admin = msg.sender;
        trustScoreDAO = _trustScoreDAO;
        active = true;
        contractCount = 0;
        isRegistrar[msg.sender] = true;
    }

    function addRegistrar(address _registrar) public onlyAdmin whenActive {
        isRegistrar[_registrar] = true;
    }

    function removeRegistrar(address _registrar) public onlyAdmin whenActive {
        isRegistrar[_registrar] = false;
    }

    function registerContractor(address _wallet, string memory _name) public onlyRegistrar whenActive {
        require(!contractors[_wallet].registered, "Already registered");
        contractors[_wallet] = Contractor({
            wallet: _wallet,
            name: _name,
            totalContracts: 0,
            totalValue: 0,
            successfulContracts: 0,
            failedContracts: 0,
            reputationScore: 50, // Neutral starting score
            registered: true
        });
        emit ContractorRegistered(_wallet, _name);
    }

    function registerContract(
        address _contractor,
        string memory _projectName,
        string memory _location,
        uint256 _contractValue,
        uint256 _duration,
        string memory _ipfsHash
    ) public onlyRegistrar whenActive {
        require(contractors[_contractor].registered, "Contractor not registered");
        require(_contractValue > 0, "Contract value must be > 0");

        uint256 contractId = contractCount;
        contracts[contractId] = DredgingContract({
            id: contractId,
            projectName: _projectName,
            location: _location,
            contractor: _contractor,
            contractValue: _contractValue,
            startDate: block.timestamp,
            endDate: block.timestamp + _duration,
            actualCost: 0,
            completed: false,
            successful: false,
            notes: "",
            timestamp: block.timestamp,
            ipfsHash: _ipfsHash
        });

        contractors[_contractor].totalContracts++;
        contractors[_contractor].totalValue += _contractValue;
        contractCount++;

        emit ContractRegistered(contractId, _contractor, _contractValue);
    }

    function completeContract(uint256 _contractId, bool _successful, uint256 _actualCost, string memory _notes)
        public
        onlyRegistrar
        whenActive
    {
        require(_contractId < contractCount, "Invalid contract");
        require(!contracts[_contractId].completed, "Already completed");

        DredgingContract storage c = contracts[_contractId];
        c.completed = true;
        c.successful = _successful;
        c.actualCost = _actualCost;
        c.notes = _notes;

        Contractor storage contractor = contractors[c.contractor];
        if (_successful) {
            contractor.successfulContracts++;
            contractor.reputationScore = min(100, contractor.reputationScore + 5);
        } else {
            contractor.failedContracts++;
            contractor.reputationScore = max(0, contractor.reputationScore - 10);
        }

        emit ContractCompleted(_contractId, _successful);
    }

    function getContract(uint256 _contractId) public view returns (DredgingContract memory) {
        require(_contractId < contractCount, "Invalid contract");
        return contracts[_contractId];
    }

    function getContractor(address _contractor) public view returns (Contractor memory) {
        return contractors[_contractor];
    }

    function getContractCount() public view returns (uint256) {
        return contractCount;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function toggleActive() public onlyAdmin {
        active = !active;
    }
}
