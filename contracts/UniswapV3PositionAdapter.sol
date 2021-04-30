// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
// import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "@uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol";
import "@uniswap/v3-periphery/contracts/libraries/PositionKey.sol";

import "./IUniswapV3PositionAdapter.sol";
import "./INonfungiblePositionManager.sol";

contract UniswapV3PositionAdapter is IUniswapV3PositionAdapter {
    /// @inheritdoc IUniswapV3PositionAdapter
    function getPositionDetails(address positionManager, uint256 tokenId)
        external
        view
        override
        returns (PositionDetail[2] memory positionDetails)
    {
        Position memory position = INonfungiblePositionManager(positionManager).positions(tokenId);

        // Compute pool address
        address pool = getPool(positionManager, position.token0, position.token1, position.fee);

        // Compute amount{0,1} that are currently in the pool
        (uint256 amount0, uint256 amount1) = getAmounts(pool, position.tickLower, position.tickUpper, position.liquidity);

        // Compute feeGrowth{0,1} that are not in tokensOwed{0,1} yet
        (uint256 feeGrowth0, uint256 feeGrowth1) = getFeeGrowths(
            positionManager,
            pool,
            position.tickLower,
            position.tickUpper,
            position.feeGrowthInside0LastX128,
            position.feeGrowthInside1LastX128,
            position.liquidity
        );

        positionDetails = [
            PositionDetail({
                token: position.token0,
                amount: amount0,
                tokensOwed: position.tokensOwed0,
                feeGrowth: feeGrowth0
            }),
            PositionDetail({
                token: position.token1,
                amount: amount1,
                tokensOwed: position.tokensOwed1,
                feeGrowth: feeGrowth1
            })
        ];
    }

    /// @notice Computes feeGrowth{0,1} that are not in tokensOwed{0,1} yet
    /// @param positionManager The address of the Uniswap V3 NonfungiblePositionManager contract
    /// @param pool Pool's address
    /// @param tickLower Position's lower tick
    /// @param tickUpper Position's upper tick
    /// @param feeGrowthInside0LastX128 Position's fee growth for token0
    /// @param feeGrowthInside1LastX128 Position's fee growth for token1
    /// @param liquidity Position's liquidity
    /// @return feeGrowth0 Amount of fees that are not saved in the position for token0
    /// @return feeGrowth1 Amount of fees that are not saved in the position for token1
    function getFeeGrowths(address positionManager, address pool, int24 tickLower, int24 tickUpper, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 liquidity) internal view returns (uint256 feeGrowth0, uint256 feeGrowth1) {
        bytes32 positionKey = PositionKey.compute(positionManager, tickLower, tickUpper);

        (, uint256 feeGrowthInside0LastX128Current, uint256 feeGrowthInside1LastX128Current, , ) = IUniswapV3Pool(pool).positions(positionKey);
        feeGrowth0 = getFeeGrowth(
            feeGrowthInside0LastX128Current,
            feeGrowthInside0LastX128,
            liquidity
        );
        feeGrowth1 = getFeeGrowth(
            feeGrowthInside1LastX128Current,
            feeGrowthInside1LastX128,
            liquidity
        );
    }

    /// @notice Computes feeGrowth given the required parameters
    /// @param feeGrowthInsideLastX128Current Pool's fee growth for the position's range
    /// @param feeGrowthInsideLastX128 Position's fee growth
    /// @param liquidity Position's liquidity
    /// @return feeGrowth Amount of fees that are not saved in the position
    function getFeeGrowth(uint256 feeGrowthInsideLastX128Current, uint256 feeGrowthInsideLastX128, uint128 liquidity) internal pure returns (uint256 feeGrowth) {
        return uint256(
            FullMath.mulDiv(
                feeGrowthInsideLastX128Current - feeGrowthInsideLastX128,
                liquidity,
                FixedPoint128.Q128
            )
        );
    }

    /// @notice Computes amount{0,1} that are currently in the pool
    /// @param pool Pool's address
    /// @param tickLower Position's lower tick
    /// @param tickUpper Position's upper tick
    /// @param liquidity Position's liquidity
    /// @return amount0 Amount of token0 that are currently in the pool
    /// @return amount1 Amount of token1 that are currently in the pool
    function getAmounts(address pool, int24 tickLower, int24 tickUpper, uint128 liquidity) internal view returns (uint256 amount0, uint256 amount1) {
        (uint160 sqrtPriceX96, , , , , , ) = IUniswapV3Pool(pool).slot0();
        (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
            sqrtPriceX96,
            TickMath.getSqrtRatioAtTick(tickLower),
            TickMath.getSqrtRatioAtTick(tickUpper),
            liquidity
        );
    }

    /// @notice Computes the pool address given the positions' parameters
    /// @param positionManager The address of the Uniswap V3 NonfungiblePositionManager contract
    /// @param token0 Position's token0
    /// @param token1 Position's token1
    /// @param fee Position's fee
    /// @return pool Address of the pool
    function getPool(address positionManager, address token0, address token1, uint24 fee) internal view returns (address pool) {
        address factory = INonfungiblePositionManager(positionManager).factory();
        pool = IUniswapV3Factory(factory).getPool(token0, token1, fee);
    }
}
