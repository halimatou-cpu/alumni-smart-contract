const DiplomaToken = artifacts.require("DiplomaToken");

module.exports = function(deployer) {
	deployer.deploy(DiplomaToken);
};
