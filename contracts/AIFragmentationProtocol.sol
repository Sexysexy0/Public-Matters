pragma solidity ^0.8.20;

contract AIFragmentationProtocol {
    address public admin;

    struct Fragmentation {
        string factor;       // e.g. privacy laws, tariffs, protectionism
        string impact;       // e.g. reduced productivity, slowed diffusion
        string remedy;       // e.g. global cooperation, scale operators
        uint256 timestamp;
    }

    Fragmentation[] public fragments;

    event FragmentationLogged(string factor, string impact, string remedy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFragmentation(string calldata factor, string calldata impact, string calldata remedy) external onlyAdmin {
        fragments.push(Fragmentation(factor, impact, remedy, block.timestamp));
        emit FragmentationLogged(factor, impact, remedy, block.timestamp);
    }

    function totalFragments() external view returns (uint256) {
        return fragments.length;
    }
}
