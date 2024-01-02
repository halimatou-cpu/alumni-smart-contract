const DiplomaToken = artifacts.require("DiplomaToken");
const truffleAssert = require("truffle-assertions");
const {
  getAllSchoolNames,
  thomasBachelorDiplomaHash,
  julienMasterDiplomaHash,
} = require("./testHelper");

contract("DiplomaToken", (accounts) => {
  let instance = null;
  let currentAccountIndex = 0;
  const contractOwner = accounts[currentAccountIndex++];
  const esgi = accounts[currentAccountIndex++];
  const iaSchool = accounts[currentAccountIndex++];
  const esgiName = "ESGI";
  const iaSchoolName = "IA School";

  const thomas = accounts[currentAccountIndex++];
  const julien = accounts[currentAccountIndex++];

  beforeEach(async () => {
    instance = await DiplomaToken.new({ from: contractOwner });
  });

  it("should create a school", async () => {
    const transactionHash = await instance.createSchool(esgiName, {
      from: esgi,
    });
    truffleAssert.eventEmitted(transactionHash, "SchoolCreated");
  });

  it("should get school name", async () => {
    await instance.createSchool(iaSchoolName, { from: iaSchool });
    const schoolName = await instance.getSchoolName(iaSchool);

    assert.equal(schoolName, iaSchoolName);
    assert.notEqual(schoolName, esgiName);

    const nonExistingSchoolName = await instance.getSchoolName(esgi);
    assert.equal(nonExistingSchoolName, "");
  });

  it("should get all schools", async () => {
    await instance.createSchool(esgiName, { from: esgi });
    await instance.createSchool(iaSchoolName, { from: iaSchool });
    const schools = await instance.getSchools();
    assert.equal(schools.length, 2);
    assert.equal(schools[0], esgi);
    assert.equal(schools[1], iaSchool);

    const schoolsNames = await getAllSchoolNames(schools, instance);
    assert.equal(schoolsNames.length, 2);
    assert.equal(schoolsNames[0], esgiName);
    assert.equal(schoolsNames[1], iaSchoolName);
  });

  describe("Diploma creation", () => {
    it("should create a diploma", async () => {
      await instance.createSchool(esgiName, { from: esgi });

      const transactionHash = await instance.createDiploma(
        "Biology Bachelor",
        thomas,
        thomasBachelorDiplomaHash,
        {
          from: esgi,
        }
      );

      truffleAssert.eventEmitted(transactionHash, "DiplomaMinted");
    });

    it("should not create a diploma if the school does not exist", async () => {
      await truffleAssert.reverts(
        instance.createDiploma(
          "Biology Bachelor",
          thomas,
          thomasBachelorDiplomaHash,
          {
            from: esgi,
          }
        ),
        "Only school can call this function"
      );
    });
  });

  describe("Getting diplomas by school or student", () => {
    it("should get all diplomas of a school", async () => {
      await instance.createSchool(esgiName, { from: esgi });
      await instance.createSchool(iaSchoolName, { from: iaSchool });
      await instance.createDiploma(
        "Biology Bachelor",
        thomas,
        thomasBachelorDiplomaHash,
        {
          from: esgi,
        }
      );
      await instance.createDiploma(
        "Science Master",
        julien,
        julienMasterDiplomaHash,
        {
          from: esgi,
        }
      );

      const esgiDiplomas = await instance.getDiplomasBySchool(esgi);
      assert.equal(esgiDiplomas.length, 2);

      assert.equal(esgiDiplomas[0]["diplomaHash"], thomasBachelorDiplomaHash);
      assert.equal(esgiDiplomas[1]["diplomaHash"], julienMasterDiplomaHash);
    });
  });

  describe("Getting diplomas by student", () => {
    it("should get all diplomas of a student", async () => {
      await instance.createSchool(esgiName, { from: esgi });
      await instance.createSchool(iaSchoolName, { from: iaSchool });
      await instance.createDiploma(
        "Biology Bachelor",
        thomas,
        thomasBachelorDiplomaHash,
        {
          from: esgi,
        }
      );
      await instance.createDiploma(
        "Science Bachelor",
        thomas,
        thomasBachelorDiplomaHash,
        {
          from: iaSchool,
        }
      );

      const thomasDiplomas = await instance.getDiplomasByStudent(thomas);
      assert.equal(thomasDiplomas.length, 2);
      assert.equal(thomasDiplomas[0]["school"], esgi);
      assert.equal(thomasDiplomas[1]["school"], iaSchool);
    });
  });

  describe("Diploma Transfer", () => {
    it("should prohibit diploma transfer", async () => {
      await instance.createSchool(esgiName, { from: esgi });

      await instance.createDiploma(
        "Biology Bachelor",
        thomas,
        thomasBachelorDiplomaHash,
        {
          from: esgi,
        }
      );

      await truffleAssert.reverts(
        instance.safeTransferFrom(thomas, julien, 0, {
          from: thomas,
        }),
        "Can't transfer this token's ownership"
      ); // 0 represents the tokenId
    });
  });
});
