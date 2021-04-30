const UniswapV3PositionAdapter = artifacts.require('UniswapV3PositionAdapter');

module.exports = (deployer, network, accounts) => {
  deployer.deploy(UniswapV3PositionAdapter, { from: accounts[0] });
};
