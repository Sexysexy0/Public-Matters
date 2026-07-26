// NeutralityFirewall.sol
// Logic: National Resource Lock
pragma solidity ^0.8.0;

contract NeutralityFirewall {
    function authorizeForceDeployment(string memory _purpose) public pure returns (bool) {
        // Goal: Strictly Defensive / National Interest Only.
        // Return False if the purpose is 'Foreign Proxy War' or 'Religious Conflict'.
        if (keccak256(abi.encodePacked(_purpose)) == keccak256(abi.encodePacked("TerritorialDefense"))) {
            return true;
        }
        return false;
    }
}
