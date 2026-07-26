// JusticePriorityEngine.sol
pragma solidity ^0.8.0;

contract JusticePriorityEngine {
    function setPriority(string memory _caseType) public pure returns (uint256) {
        if (keccak256(abi.encodePacked(_caseType)) == keccak256(abi.encodePacked("Plunder"))) {
            return 1; // Highest Priority
        }
        return 99; // Low Priority for personal feelings
    }
}
