// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BroadcasterRegistry
 * @dev A registry of approved broadcasters (philosophers, sages, representatives)
 * who can emit public messages on behalf of the kingdom.
 */
contract BroadcasterRegistry {
    address public immutable emperor;
    mapping(address => bool) public isBroadcaster;
    address[] public broadcasters;

    event BroadcasterAdded(address indexed broadcaster);
    event BroadcasterRemoved(address indexed broadcaster);
    event Broadcast(address indexed broadcaster, string message);

    modifier onlyEmperor() {
        require(msg.sender == emperor, "Only the emperor");
        _;
    }

    modifier onlyBroadcaster() {
        require(isBroadcaster[msg.sender], "Not a broadcaster");
        _;
    }

    constructor(address[] memory _initialBroadcasters) {
        emperor = msg.sender;
        for (uint256 i = 0; i < _initialBroadcasters.length; i++) {
            _addBroadcaster(_initialBroadcasters[i]);
        }
    }

    function addBroadcaster(address _new) external onlyEmperor {
        require(!isBroadcaster[_new], "Already a broadcaster");
        _addBroadcaster(_new);
    }

    function removeBroadcaster(address _old) external onlyEmperor {
        require(isBroadcaster[_old], "Not a broadcaster");
        isBroadcaster[_old] = false;
        emit BroadcasterRemoved(_old);
    }

    function broadcast(string calldata _message) external onlyBroadcaster {
        emit Broadcast(msg.sender, _message);
    }

    function _addBroadcaster(address _addr) internal {
        isBroadcaster[_addr] = true;
        broadcasters.push(_addr);
        emit BroadcasterAdded(_addr);
    }

    function getBroadcasters() external view returns (address[] memory) {
        return broadcasters;
    }
}
