import { ethers } from "hardhat";

async function main() {
  const nftContractFactory = await ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  console.log("Minted NFT #2");
}

async function runMain() {
  try {
    await main();
    process.exitCode = 0;
  } catch (error) {
    console.log(error);
    process.exitCode = 1;
  }
}

runMain();
