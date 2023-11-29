async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("DEPLOYIN_TO:", deployer.address);

  const token = await ethers.deployContract("UNIT");

  console.log("CONTRACT_ADDRESS:", await token.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });