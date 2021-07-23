# uniswap-v3-position-adapter

This contract is used to interpret Uniswap V3 positions.

The mainnet address is [0x497160ebC6CbF3556826540737D255c002f80360](https://etherscan.io/address/0x497160ebC6CbF3556826540737D255c002f80360#code).

The rinkeby testnet address is [0x4B774683346df9271f5bDbE03e15F20A74dc64Cc](https://rinkeby.etherscan.io/address/0x4B774683346df9271f5bDbE03e15F20A74dc64Cc#code).

> NOTE For all the networks, **NonfungibleTokenPositionDescriptor** address is [0x91ae842A5Ffd8d12023116943e72A606179294f3](https://etherscan.io/address/0x91ae842A5Ffd8d12023116943e72A606179294f3#code).

Every Uniswap V3 position is interpreted as a pair of `PositionDetail` structs. Every struct is an underlying token address and the following three numbers:

1. amount of tokens that are currently used as a pool liquidity (`amount`);
2. amount of tokens that are not used as a pool liquidity, but are still in Unispwap's **NonfungiblePositionManager** contract (`tokensOwed`);
3. amount of tokens that will be collected as fees on the next interaction with Uniswap's **NonfungiblePositionManager** contract (`fee`).

```
struct PositionDetail {
    address token;
    uint256 amount;
    uint256 tokensOwed;
    uint256 fee;
}
```
