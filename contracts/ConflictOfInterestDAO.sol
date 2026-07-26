// ConflictOfInterestDAO.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ConflictOfInterestDAO is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Disclosure {
        uint256 id;
        string member;    // e.g. "Rep. Garin"
        string tie;       // e.g. "Pharma industry link"
        bool disclosed;
    }

    uint256 public disclosureCount;
    mapping(uint256 => Disclosure) public disclosures;

    event DisclosureFiled(uint256 id, string member, string tie);

    function fileDisclosure(string memory member, string memory tie) public {
        disclosureCount++;
        disclosures[disclosureCount] = Disclosure(disclosureCount, member, tie, true);
        emit DisclosureFiled(disclosureCount, member, tie);
    }
}
