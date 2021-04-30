async function main() {

  const [deployer] = await ethers.getSigners();

  console.log(
    'Deploying UniswapV3PositionAdapter contract with the account:',
    deployer.address
  );

  console.log('Account balance:', (await deployer.getBalance()).toString());

  const UniswapV3PositionAdapter = await ethers.getContractFactory('UniswapV3PositionAdapter');
  const uniswapV3PositionAdapter = await UniswapV3PositionAdapter.deploy();

  console.log('Adapter address:', uniswapV3PositionAdapter.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
