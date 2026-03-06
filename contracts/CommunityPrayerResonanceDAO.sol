// CommunityPrayerResonanceDAO.sol
pragma solidity ^0.8.0;

contract CommunityPrayerResonanceDAO {
    struct Prayer {
        uint256 id;
        string community;  // e.g. "San Fernando Parish"
        string intention;  // e.g. "Collective strength against darkness"
        bool active;
    }

    uint256 public prayerCount;
    mapping(uint256 => Prayer) public prayers;

    event PrayerActivated(uint256 id, string community, string intention);

    function activatePrayer(string memory community, string memory intention) public {
        prayerCount++;
        prayers[prayerCount] = Prayer(prayerCount, community, intention, true);
        emit PrayerActivated(prayerCount, community, intention);
    }
}
