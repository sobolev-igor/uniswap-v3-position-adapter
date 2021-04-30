# uniswap-v3-position-adapter

This contract is used to interpret Uniswap V3 positions.

Every Uniswap V3 position is interpreted as a pair of `PositionDetail` structs. Every struct is an underlying token address and the following three numbers:

1. amount of tokens that are currently used as a pool liquidity (`amount`);
2. amount of tokens that are not used as a pool liquidity, but are still in Unispwap's **NonfungiblePositionManager** contract (`tokensOwed`);
3. amount of tokens that will be collected as fees on the next interaction with Uniswap's **NonfungiblePositionManager** contract (`feeGrowth`).

```
struct PositionDetail {
    address token;
    uint256 amount;
    uint256 tokensOwed;
    uint256 feeGrowth;
}
```
