const { logger } = require('ethers');

const { ethers } = require('hardhat');

const logPositionDetails = (positionDetails, tokenId) => {
  logger.info(`The position #${tokenId} details:`);
  logPositionDetail(positionDetails[0]);
  logPositionDetail(positionDetails[1]);
};

const logPositionDetail = (positionDetail) => {
  logger.info(`Token address: ${positionDetail.token.toString()}`);
  logger.info(`In-pool amount: ${positionDetail.amount.toString()}`);
  logger.info(`Out-pool amount: ${positionDetail.tokensOwed.toString()}`);
  logger.info(`Fees amount: ${positionDetail.feeGrowth.toString()}`);
};

describe('UniswapV3PositionAdapter', () => {
  let UniswapV3PositionAdapter;
  let adapter;
  let rinkebyUniswapPositionManagerAddress = '0x3255160392215494bee8B5aBf8C4C40965d0986C';

  before(async () => {
    UniswapV3PositionAdapter = await ethers.getContractFactory('UniswapV3PositionAdapter');
  });

  beforeEach(async () => {
    adapter = await UniswapV3PositionAdapter.deploy();
  });

  it('should be correct position interpretation', async () => {
    const tokenId = 8;
    let positionDetails = await adapter.getPositionDetails(rinkebyUniswapPositionManagerAddress, tokenId);
    logPositionDetails(positionDetails, tokenId);
  });
});
