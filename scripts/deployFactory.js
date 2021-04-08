// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  
  const Token = await hre.ethers.getContractFactory('Token');
  const token = await Token.deploy();
  await token.deployed();

  console.log("Token template deployed to:", token.address);

  const TokenFactory = await hre.ethers.getContractFactory("TokenFactory");
  const tokenFactory = await TokenFactory.deploy(token.address);

  await tokenFactory.deployed();

  console.log("TokenFactory deployed to:", tokenFactory.address);

  const newToken = await tokenFactory.callStatic.createToken("TestToken", "TEST", 18, tokenFactory.address, true);
  await tokenFactory.createToken("TestToken", "TEST", 18, tokenFactory.address, true);

  console.log("New Token deployed via TokenFactory to:", newToken);

  const deployedToken = Token.attach(newToken);
  const name = await deployedToken.name();
  const symbol = await deployedToken.symbol();
  const decimals = await deployedToken.decimals();
  console.log("Token Vanity:", { name, symbol, decimals })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
