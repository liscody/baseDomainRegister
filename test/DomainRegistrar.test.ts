/* eslint-disable */
import type { SnapshotRestorer } from "@nomicfoundation/hardhat-network-helpers";
import { takeSnapshot } from "@nomicfoundation/hardhat-network-helpers";

import { expect } from "chai";
import { ethers, upgrades } from "hardhat";
import type { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

import type { DomainsRegistry, MyToken } from "../typechain-types";

const AddressZero = ethers.ZeroAddress;
// eslint-disable-next-line @typescript-eslint/no-unused-vars
describe("Reg: test", function () {
    let snapshotA: SnapshotRestorer;

    // Signers.
    let deployer: SignerWithAddress, owner: SignerWithAddress;
    let user1: SignerWithAddress, user2: SignerWithAddress;
    let eve: SignerWithAddress;

    let beneficiary: SignerWithAddress;

    let contract: any;
    let token: MyToken;

    let registrationFee: any;
    let subdomainPrice: any;

    before(async () => {
        [owner, user1, beneficiary, eve] = await ethers.getSigners();
        deployer = owner;

        registrationFee = ethers.parseEther("0.5");

        subdomainPrice = ethers.parseEther("0.1");

        // deploy my token
        const MyToken = await ethers.getContractFactory("MyToken");
        token = await MyToken.deploy(owner.address);
        const tokenAddr = await token.getAddress();
        console.log("tokenAddr", tokenAddr);

        // deploy the contract
        const DomainsRegistry = await ethers.getContractFactory("DomainsRegistry");
        contract = await upgrades.deployProxy(DomainsRegistry, [registrationFee, subdomainPrice], {
            initializer: "initialize"
        });

        const contractAddr = await contract.getAddress();
        console.log("contractAddr", contractAddr);

        snapshotA = await takeSnapshot();
    });

    afterEach(async () => await snapshotA.restore());

    describe("# Register domain ", function () {
        it("Should register domain", async function () {
            // step 1
            // register domain 1 level -> com
            let domainNames = ["com"];
            await contract.registerDomain(domainNames, AddressZero, { value: registrationFee });

            // step 2
            // register domain 2 level -> domain.com
            domainNames = ["domain", "com"];
            await contract.registerDomain(domainNames, AddressZero, { value: registrationFee + registrationFee });

            // step 3
            // register domain 3 level -> my.domain.com
            domainNames = ["my", "domain", "com"];
            await contract.registerDomain(domainNames, AddressZero, {
                value: registrationFee + subdomainPrice + registrationFee
            });
        });
    });
});
