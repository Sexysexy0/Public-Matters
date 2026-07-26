// WorkFlowTransparencyProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorkFlowTransparencyProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Milestone {
        string taskName;
        string outputHash; // Hash of the document/action
        uint256 completionTime;
        bool isVerifiedByOversight;
    }

    mapping(address => Milestone[]) public agencyLogs;

    function logOutput(string memory _task, string memory _hash) public {
        agencyLogs[msg.sender].push(Milestone(_task, _hash, block.timestamp, false));
    }

    function verifyOutput(address _agency, uint256 _index) public {
        // Oversight committee verifies if the WFH output is valid and substantial
        agencyLogs[_agency][_index].isVerifiedByOversight = true;
    }
}
