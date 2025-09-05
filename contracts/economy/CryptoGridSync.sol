// Balances crypto mining with renewable energy sanctums
pragma solidity ^0.8.30;

contract CryptoGridSync {
    address public steward;
    mapping(string => uint256) public energySourceRatio;
    event GridSynced(string source, uint256 ratio);

    constructor() {
        steward = msg.sender;
        energySourceRatio["solar"] = 40;
        energySourceRatio["wind"] = 30;
        energySourceRatio["hydro"] = 20;
        energySourceRatio["biomass"] = 10;
    }

    function updateRatio(string memory source, uint256 ratio) public {
        require(msg.sender == steward, "Unauthorized steward");
        energySourceRatio[source] = ratio;
        emit GridSynced(source, ratio);
    }

    function getRatio(string memory source) public view returns (uint256) {
        return energySourceRatio[source];
    }
}
