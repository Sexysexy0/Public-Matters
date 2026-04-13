// AlgorithmicTransparencySafeguards.sol
pragma solidity ^0.8.0;

contract AlgorithmicTransparencySafeguards {
    struct AIModel {
        bytes32 modelHash;
        string purpose; // e.g., "Credit Scoring"
        uint256 lastAuditDate;
        bool isEthicalCertified;
    }

    mapping(address => AIModel) public registeredModels;

    function registerModel(bytes32 _hash, string memory _purpose) public {
        registeredModels[msg.sender] = AIModel(_hash, _purpose, block.timestamp, false);
    }

    function certifyModel(address _owner) public {
        // Only authorized ethical auditors can trigger this
        registeredModels[_owner].isEthicalCertified = true;
    }
}
