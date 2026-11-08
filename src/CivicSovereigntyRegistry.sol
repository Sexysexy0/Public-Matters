// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title CivicSovereigntyRegistry
 * @notice On-chain civic identity for citizens.
 *         Privacy-preserving (uses salted hashes) and tracks civic contribution.
 */
contract CivicSovereigntyRegistry {
    OperatorPrivileges public immutable privileges;

    struct Citizen {
        bytes32 identityHash;   // keccak256(NationalID + salt) for privacy
        bytes32 regionHash;     // Barangay/Municipality hash
        uint256 civicScore;     // Starts at 100, goes up or down based on actions
        bool isRegistered;
        uint256 registeredAt;
    }

    mapping(address => Citizen) public citizens;
    mapping(bytes32 => uint256) public populationByRegion;
    uint256 public totalPopulation;

    event CitizenRegistered(address indexed wallet, bytes32 indexed regionHash);
    event CivicScoreUpdated(address indexed citizen, uint256 oldScore, uint256 newScore, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice Self-registration. Citizens provide their hashed ID and region.
     */
    function registerCitizen(bytes32 identityHash, bytes32 regionHash) external {
        require(!citizens[msg.sender].isRegistered, "Already registered");
        require(identityHash != bytes32(0), "identityHash=0");
        require(regionHash != bytes32(0), "regionHash=0");

        citizens[msg.sender] = Citizen({
            identityHash: identityHash,
            regionHash: regionHash,
            civicScore: 100, // Start with a perfect score
            isRegistered: true,
            registeredAt: block.timestamp
        });

        populationByRegion[regionHash]++;
        totalPopulation++;

        emit CitizenRegistered(msg.sender, regionHash);
    }

    /**
     * @notice Operators (e.g., LGU officials) can adjust the civic score based on on-chain verifiable actions.
     */
    function updateCivicScore(address citizen, uint256 newScore, string calldata reason) external onlyOperator {
        require(citizens[citizen].isRegistered, "Citizen not found");
        uint256 oldScore = citizens[citizen].civicScore;
        citizens[citizen].civicScore = newScore;
        emit CivicScoreUpdated(citizen, oldScore, newScore, reason);
    }

    function getCitizen(address wallet) external view returns (Citizen memory) {
        return citizens[wallet];
    }
}
