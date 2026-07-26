// DataSovereigntySafeguards.sol
pragma solidity ^0.8.0;

contract DataSovereigntySafeguards {
    struct DataVault {
        address owner;
        bytes32 dataRoot; // Merkle root of encrypted data
        mapping(address => uint256) accessExpiry;
    }

    mapping(address => DataVault) private vaults;

    function grantAccess(address _consumer, uint256 _duration) public {
        vaults[msg.sender].accessExpiry[_consumer] = block.timestamp + _duration;
    }

    function checkAccess(address _owner, address _consumer) public view returns (bool) {
        return block.timestamp <= vaults[_owner].accessExpiry[_consumer];
    }
}
