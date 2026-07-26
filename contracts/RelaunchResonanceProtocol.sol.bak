// RelaunchResonanceProtocol.sol
pragma solidity ^0.8.0;

contract RelaunchResonanceProtocol {
    struct Relaunch {
        uint256 id;
        string domain;    // e.g. "Manufacturing Plant"
        string plan;      // e.g. "Phased reopening"
        string outcome;   // e.g. "Operational"
        uint256 timestamp;
    }

    uint256 public relaunchCount;
    mapping(uint256 => Relaunch) public relaunches;

    event RelaunchLogged(uint256 id, string domain, string plan, string outcome);

    function logRelaunch(string memory domain, string memory plan, string memory outcome) public {
        relaunchCount++;
        relaunches[relaunchCount] = Relaunch(relaunchCount, domain, plan, outcome, block.timestamp);
        emit RelaunchLogged(relaunchCount, domain, plan, outcome);
    }
}
