const crypto = require('crypto');
 
async function getAllSchoolNames(schools, instance) {
	const promises = schools.map((school) => instance.getSchoolName(school));
	const names = await Promise.all(promises);
	return names;
}

function hashDocument(document) {
	const hash = crypto.createHash('sha256');
	hash.update(document);
	return hash.digest('hex');
}

const thomasBachelorDiplomaHash = hashDocument("Thomas Bachelor in Biology Diploma"); 
const julienMasterDiplomaHash = hashDocument("Julien Master in Computer Science Diploma");

module.exports = { 
	getAllSchoolNames,
	hashDocument,
	thomasBachelorDiplomaHash,
	julienMasterDiplomaHash,
};