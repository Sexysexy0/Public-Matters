// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ImmutablePolicyLedger {
    address public guardian;
    uint256 public totalPolicies;

    struct Policy {
        uint256 policyId;
        string title;
        string ipfsHash;      // Cryptographic hash (link) ng buong legal o etikal na dokumento
        uint256 enactedAt;    // Petsa kung kailan ipinatupad ang batas
        bool isActive;        // Pwedeng i-deprecate pero hindi pwedeng burahin ang kasaysayan
    }

    mapping(uint256 => Policy) public registry;

    event PolicyEnacted(uint256 indexed policyId, string title, string ipfsHash);
    event PolicyDeprecated(uint256 indexed policyId, string reason);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Anonymous Guardian can enact policies.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Magpatupad ng bagong batas o alituntunin para sa mga institusyon
    function enactPolicy(string memory _title, string memory _ipfsHash) public onlyGuardian {
        totalPolicies++;
        
        registry[totalPolicies] = Policy({
            policyId: totalPolicies,
            title: _title,
            ipfsHash: _ipfsHash,
            enactedAt: block.timestamp,
            isActive: true
        });

        emit PolicyEnacted(totalPolicies, _title, _ipfsHash);
    }

    // I-deprecate o ihinto ang pagpapatupad ng isang lumang patakaran (nang hindi binubura ang rekord)
    function deprecatePolicy(uint256 _policyId, string memory _reason) public onlyGuardian {
        require(registry[_policyId].enactedAt > 0, "Error: Policy does not exist.");
        require(registry[_policyId].isActive, "Policy is already inactive.");
        
        registry[_policyId].isActive = false;
        emit PolicyDeprecated(_policyId, _reason);
    }

    // Kuhanin ang buong detalye ng isang partikular na batas
    function getPolicy(uint256 _policyId) public view returns (
        string memory title, 
        string memory ipfsHash, 
        uint256 enactedAt, 
        bool isActive
    ) {
        Policy memory policy = registry[_policyId];
        require(policy.enactedAt > 0, "Error: Policy not found.");
        return (policy.title, policy.ipfsHash, policy.enactedAt, policy.isActive);
    }
}
