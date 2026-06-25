// ReliefDAO.sol
pragma solidity ^0.8.0;

contract ReliefDAO {
    struct Aid {
        uint256 id;
        string partner;   // e.g. "Local NGO"
        uint256 amount;   // e.g. "1000 units of supplies"
        string purpose;   // e.g. "Medical kits"
        bool delivered;
    }

    uint256 public aidCount;
    mapping(uint256 => Aid) public aids;

    event AidDelivered(uint256 id, string partner, uint256 amount, string purpose);

    function deliverAid(string memory partner, uint256 amount, string memory purpose) public {
        aidCount++;
        aids[aidCount] = Aid(aidCount, partner, amount, purpose, true);
        emit AidDelivered(aidCount, partner, amount, purpose);
    }
}
