const MyLearn = artifacts.require("MyLearn.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(MyLearn);
};
