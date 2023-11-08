// const DiplomaToken = artifacts.require("DiplomaToken");

// module.exports = function(deployer) {
// 	deployer.deploy(DiplomaToken);
// };
const Test = artifacts.require("Test");

module.exports = function(deployer) {
	deployer.deploy(Test);
};

