// DeploymentProtocol.sol
pragma solidity ^0.8.0;

contract DeploymentProtocol {
    struct Release {
        uint256 id;
        string domain;       // e.g. "Smart Contract"
        string description;  // e.g. "Mainnet deployment"
        bool completed;
        uint256 timestamp;
    }

    uint256 public releaseCount;
    mapping(uint256 => Release) public releases;

    event ReleaseLogged(uint256 id, string domain, string description, bool completed);

    function logRelease(string memory domain, string memory description, bool completed) public {
        releaseCount++;
        releases[releaseCount] = Release(releaseCount, domain, description, completed, block.timestamp);
        emit ReleaseLogged(releaseCount, domain, description, completed);
    }
}
