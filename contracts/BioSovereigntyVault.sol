// BioSovereigntyVault.sol
pragma solidity ^0.8.0;

contract BioSovereigntyVault {
    mapping(address => bytes32) private dnaHash;
    mapping(address => bool) public researchAccess;

    function secureDNA(bytes32 _hash) public {
        dnaHash[msg.sender] = _hash;
    }

    function grantResearchAccess(address _lab) public payable {
        // Direct payment to the human "data donor"
        researchAccess[_lab] = true;
    }
}
