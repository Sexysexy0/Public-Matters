// RelocationProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RelocationProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Site {
        uint256 id;
        string location;   // e.g. "Desert Zone"
        string purpose;    // e.g. "AI Data Center"
        bool active;
        uint256 timestamp;
    }

    uint256 public siteCount;
    mapping(uint256 => Site) public sites;

    event SiteActivated(uint256 id, string location, string purpose);

    function activateSite(string memory location, string memory purpose) public {
        siteCount++;
        sites[siteCount] = Site(siteCount, location, purpose, true, block.timestamp);
        emit SiteActivated(siteCount, location, purpose);
    }
}
