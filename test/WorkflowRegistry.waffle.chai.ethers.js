// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe(
//   "Gemini/Janus contract waffle/chai/ethers test",
//   function () {

//     // Wallets
//     let deployer;

//     // Contracts
//     let ERC1820RegistryContract;
//     let erc18280;
//     let WorkflowRegistryContract;
//     let workflow;
//     let ERC1820RegistryContract;
//     let workflow;

//     beforeEach(
//       async function () {
//         [
//           deployer
//         ] = await ethers.getSigners();

//         ERC1820RegistryContract = await ethers.getContractFactory("ERC1820Registry");
//         erc18280 = await ERC1820RegistryContract.connect( deployer ).deploy( deployer.address );
        
//         WorkflowRegistryContract = await ethers.getContractFactory("WorkflowRegistry");
//         workflow = await MockRegWorkflowRegistryContractistryContract.connect( deployer ).deploy( [erc18280.address], deployer.address );

//       }
//     );

//     describe(
//       "MockWorkflow",
//       function () {
//         it( 
//           "InterfaceTest", 
//           async function() {
//             console.log("Test::MockWorkflow::InterfaceTest: Execute workflow using interfaces.");
//             expect( await workflow.registryManager() ).to.equal( deployer.address );
//             // console.log("Test::MockWorkflow::InterfaceTest: check message value after interface usage.");
//             // expect( await storage.message() ).to.equal( "Hello World" );
//             // console.log("Test::MockWorkflow::InterfaceTest: check number value after interface usage.");
//             // expect( await storage.number() ).to.equal( 1 );
//           }
//         );

//         // it( 
//         //   "CallTest", 
//         //   async function() {
//         //     console.log("Test::MockWorkflow::CallTest: Execute workflow using interfaces.");
//         //     await controller.executeWorkflowWithSelectors( storage.address, registry.address, "Hello World", 1 );
//         //     // console.log("Test::MockWorkflow::InterfaceTest: check message value after interface usage.");
//         //     // expect( await storage.message() ).to.equal( "Hello World" );
//         //     // console.log("Test::MockWorkflow::InterfaceTest: check number value after interface usage.");
//         //     // expect( await storage.number() ).to.equal( 1 );
//         //   }
//         // );
//       }
//     );
//   }
// );