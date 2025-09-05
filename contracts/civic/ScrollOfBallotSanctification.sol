// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract ScrollOfBallotSanctification {
    struct Ballot {
        address voter;
        string district;
        uint256 timestamp;
        bool sanctified;
        bool briberyDetected;
        string auditNote;
    }

    mapping(uint256 => Ballot) public ballotLog;
    uint256 public ballotCount;

    event BallotSanctified(uint256 indexed ballotId, address voter, string district, bool sanctified, string auditNote, uint256 timestamp);
    event BriberyAlert(uint256 indexed ballotId, address voter, string district, string auditNote, uint256 timestamp);

    function castBallot(address voter, string calldata district, bool briberyDetected, string calldata auditNote) external {
        ballotCount++;
        bool sanctified = !briberyDetected;

        ballotLog[ballotCount] = Ballot(voter, district, block.timestamp, sanctified, briberyDetected, auditNote);

        if (briberyDetected) {
            emit BriberyAlert(ballotCount, voter, district, auditNote, block.timestamp);
        } else {
            emit BallotSanctified(ballotCount, voter, district, sanctified, auditNote, block.timestamp);
        }
    }

    function getBallot(uint256 ballotId) external view returns (Ballot memory) {
        require(ballotId > 0 && ballotId <= ballotCount, "Invalid ballot ID");
        return ballotLog[ballotId];
    }
}
