// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FranchiseContinuityOracle {
    struct Continuity {
        address overseer;
        string franchise;
        string safeguard;
        uint256 timestamp;
        bool anchored;
    }

    Continuity[] public continuities;

    event ContinuityLogged(address indexed overseer, string franchise, string safeguard);
    event ContinuityAnchored(uint256 indexed id, address verifier);

    function logContinuity(string memory _franchise, string memory _safeguard) public {
        continuities.push(Continuity(msg.sender, _franchise, _safeguard, block.timestamp, false));
        emit ContinuityLogged(msg.sender, _franchise, _safeguard);
    }

    function anchorContinuity(uint256 _id) public {
        require(_id < continuities.length, "Invalid ID");
        continuities[_id].anchored = true;
        emit ContinuityAnchored(_id, msg.sender);
    }

    function getContinuity(uint256 _id) public view returns (Continuity memory) {
        require(_id < continuities.length, "Invalid ID");
        return continuities[_id];
    }

    function totalContinuities() public view returns (uint256) {
        return continuities.length;
    }
}
