const Rentable = artifacts.require("Rent");

module.exports = function (deployer) {
  deployer.deploy(Rentable);
};
