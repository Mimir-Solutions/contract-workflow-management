const { expect } = require("chai");
const { ethers } = require("hardhat");

describe(
  "Gemini/Janus contract waffle/chai/ethers test",
  function () {

    // Wallets
    let deployer;

    // Contracts
    let MockFrontControllerContract;
    let controller;
    let MockStorageContract;
    let storage;
    let MockRegistryContract;
    let registry;

    beforeEach(
      async function () {
        [
          deployer
        ] = await ethers.getSigners();

        MockRegistryContract = await ethers.getContractFactory("MockRegistry");
        registry = await MockRegistryContract.connect( deployer ).deploy();

        MockStorageContract = await ethers.getContractFactory("MockStorage");
        storage = await MockStorageContract.connect( deployer ).deploy();
                
        MockFrontControllerContract = await ethers.getContractFactory("MockFrontController");
        controller = await MockFrontControllerContract.connect( deployer ).deploy();
      }
    );

    describe(
      "MockWorkflow",
      function () {
        it( 
          "InterfaceTest", 
          async function() {
            console.log("Test::MockWorkflow::InterfaceTest: Execute workflow using interfaces.");
            await controller.executeWorkflowWithInterfaces( storage.address, "Hello World", 1 );
            // console.log("Test::MockWorkflow::InterfaceTest: check message value after interface usage.");
            // expect( await storage.message() ).to.equal( "Hello World" );
            // console.log("Test::MockWorkflow::InterfaceTest: check number value after interface usage.");
            // expect( await storage.number() ).to.equal( 1 );
          }
        );

        it( 
          "CallTest", 
          async function() {
            console.log("Test::MockWorkflow::CallTest: Execute workflow using interfaces.");
            await controller.executeWorkflowWithSelectors( storage.address, registry.address, "Hello World", 1 );
            // console.log("Test::MockWorkflow::InterfaceTest: check message value after interface usage.");
            // expect( await storage.message() ).to.equal( "Hello World" );
            // console.log("Test::MockWorkflow::InterfaceTest: check number value after interface usage.");
            // expect( await storage.number() ).to.equal( 1 );
          }
        );
      }
    );
  }
);