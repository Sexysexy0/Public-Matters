// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TradeSurgeOracle {
    struct Campaign {
        string name;
        uint256 emotionalResonance;
        uint256 exportVolume;
        bool active;
    }

    mapping(string => Campaign) public campaigns;
    string[] public activeCampaigns;

    event CampaignActivated(string name, uint256 resonance);
    event CampaignUpdated(string name, uint256 newResonance, uint256 newVolume);

    function activateCampaign(string memory _name, uint256 _resonance, uint256 _volume) public {
        campaigns[_name] = Campaign(_name, _resonance, _volume, true);
        activeCampaigns.push(_name);
        emit CampaignActivated(_name, _resonance);
    }

    function updateCampaign(string memory _name, uint256 _resonance, uint256 _volume) public {
        require(campaigns[_name].active, "Campaign not active");
        campaigns[_name].emotionalResonance = _resonance;
        campaigns[_name].exportVolume = _volume;
        emit CampaignUpdated(_name, _resonance, _volume);
    }

    function getActiveCampaigns() public view returns (string[] memory) {
        return activeCampaigns;
    }
}
