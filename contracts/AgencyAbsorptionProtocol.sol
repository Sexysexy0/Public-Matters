// AgencyAbsorptionProtocol.sol
pragma solidity ^0.8.0;

contract AgencyAbsorptionProtocol {
    struct Recruit {
        address worker;
        address agency;
        bool absorbed;
    }

    mapping(address => Recruit) public recruits;
    mapping(address => uint256) public agencyRewards;

    event WorkerRecruited(address indexed worker, address indexed agency);
    event WorkerAbsorbed(address indexed worker, address indexed company);
    event AgencyRewarded(address indexed agency, uint256 reward);

    // Agency recruits worker
    function recruitWorker(address worker, address agency) public {
        recruits[worker] = Recruit(worker, agency, false);
        emit WorkerRecruited(worker, agency);
    }

    // Company absorbs worker directly
    function absorbWorker(address worker, address company) public {
        recruits[worker].absorbed = true;
        emit WorkerAbsorbed(worker, company);

        // Reward agency per head
        agencyRewards[recruits[worker].agency] += 1;
        emit AgencyRewarded(recruits[worker].agency, agencyRewards[recruits[worker].agency]);
    }
}
