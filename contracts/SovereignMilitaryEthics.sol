// SovereignMilitaryEthics.sol
// Logic: Strict Non-Interventionist Funding
pragma solidity ^0.8.0;

contract SovereignMilitaryEthics {
    function approveForeignAid(string memory _purpose) public pure returns (string memory) {
        if (keccak256(abi.encodePacked(_purpose)) == keccak256(abi.encodePacked("Proxy_War"))) {
            return "TRANSACTION_DENIED: ETHICAL_VIOLATION";
        }
        return "TRANSACTION_PENDING_VOTER_APPROVAL";
    }
}
