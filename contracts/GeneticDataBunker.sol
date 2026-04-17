// GeneticDataBunker.sol
pragma solidity ^0.8.0;

contract GeneticDataBunker {
    struct GenomicProfile {
        bytes32 dataHash; // Encrypted genetic code
        bool accessGranted;
        uint256 usageFee;
    }

    mapping(address => GenomicProfile) public dnaVault;

    function secureDNA(bytes32 _hash, uint256 _fee) public {
        dnaVault[msg.sender] = GenomicProfile(_hash, false, _fee);
    }

    function authorizeResearch(address _researcher) public payable {
        require(msg.value >= dnaVault[msg.sender].usageFee, "Payment required for bio-data");
        dnaVault[msg.sender].accessGranted = true;
        // Payment goes to the individual, not the lab
        payable(msg.sender).transfer(msg.value);
    }
}
