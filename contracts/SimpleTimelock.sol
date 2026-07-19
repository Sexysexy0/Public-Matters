// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleTimelock
/// @notice Queue transactions with enforced delay to allow review/cancellation
contract SimpleTimelock {
    uint public delay;
    mapping(bytes32 => uint) public queued; // txHash -> executeAfter

    event Queued(bytes32 indexed txHash, uint executeAfter);
    event Executed(bytes32 indexed txHash);
    event Cancelled(bytes32 indexed txHash);

    constructor(uint _delay) { delay = _delay; }

    function queue(address to, uint value, bytes calldata data, uint salt) external returns (bytes32) {
        bytes32 h = keccak256(abi.encode(to, value, data, salt));
        require(queued[h] == 0, "already queued");
        queued[h] = block.timestamp + delay;
        emit Queued(h, queued[h]);
        return h;
    }

    function cancel(address to, uint value, bytes calldata data, uint salt) external {
        bytes32 h = keccak256(abi.encode(to, value, data, salt));
        require(queued[h] != 0, "not queued");
        queued[h] = 0;
        emit Cancelled(h);
    }

    function execute(address to, uint value, bytes calldata data, uint salt) external {
        bytes32 h = keccak256(abi.encode(to, value, data, salt));
        uint when = queued[h];
        require(when != 0 && block.timestamp >= when, "not ready");
        queued[h] = 0;
        (bool ok, ) = to.call{value: value}(data);
        require(ok, "call failed");
        emit Executed(h);
    }

    receive() external payable {}
}
