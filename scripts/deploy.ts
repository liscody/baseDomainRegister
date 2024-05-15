// // This is a script for deployment and automatically verification of all the contracts (`contracts/`).
// /* eslint-disable */

// import hre from "hardhat";
// // @ts-ignore
// const ethers = hre.ethers;

// // solhint ignore next line
// // @ts-ignore
// import type { Lock } from "../typechain-types";

// async function main(): Promise<Lock> {
//     // Deployment.
//     const Contract = (await ethers.getContractFactory("Lock")) as any;
//     // get current time
//     const currentTime = Math.floor(Date.now() / 1000);
//     const instance = await Contract.deploy(currentTime);
//     // await instance.target();
//     console.log("Contract deployed to:", await instance.getAddress());
//     // stop execution here
//     return instance;
// }

// export { main };

// main()
//     .then(() => {
//         process.exit(0); // Exit with success status
//     })
//     .catch((error) => {
//         console.error(error);
//         process.exit(1); // Exit with error status
//     });
// // npx hardhat run scripts/deployment/deploy.ts --network mumbai
// // npx hardhat run scripts/deploy.ts --network localhost

// /* eslint-disable */
