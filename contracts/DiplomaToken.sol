// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DiplomaToken is ERC721, Ownable {
	uint256 private _nextTokenId;

	constructor() ERC721("DiplomaToken", "DTK") {}

	struct Diploma {
		string name;
		address school;
		address student;
		string diplomaHash;
		uint256 date;
	}

	struct School {
		string name;
		address school;
	}

	School[] public schools;
	address[] public schoolsAddresses;

	event DiplomaMinted(uint256 tokenId, string name, address school, address student, string diplomaHash, uint256 date);
	event SchoolCreated(string name, address school);
	
	// sur le front: mettre un form qui créé une école et appelle la fonction createSchool
	function createSchool(string memory _name) public {
		schoolsAddresses.push(msg.sender);
		emit SchoolCreated(_name, msg.sender);
	}

	function getSchoolName(address _school) public view returns (string memory) {
		for (uint256 i = 0; i < schools.length; i++) {
			if (schools[i] == _school) {
				return schools[i].name;
			}
		}
		return "";
	}

	modifier onlySchool() {
		bool isSchool = false;
		for (uint256 i = 0; i < _schools.length; i++) {
			if (_schools[i] == msg.sender) {
				isSchool = true;
				break;
			}
		}
		require(isSchool, "Only school can call this function");
		_;
	}

	function createDiploma(
		string memory _name,
		address _student,
		string memory _hash
	) public onlySchool {
		_safeMint(_student, _nextTokenId);
		_nextTokenId++;
		emit DiplomaMinted(_nextTokenId, _name, msg.sender, _student, _hash, block.timestamp);
	}

	function getDiplomas(address _student) public view returns (Diploma[] memory) {
		Diploma[] memory _diplomas = new Diploma[](balanceOf(_student));
		uint256 _diplomaCount = 0;
		for (uint256 i = 0; i < _nextTokenId; i++) {
			if (ownerOf(i) == _student) {
				_diplomas[_diplomaCount] = diplomas[i];
				_diplomaCount++;
			}
		}
		return _diplomas;
	}

	function getDiplomas(address _school) public view returns (Diploma[] memory) {
		Diploma[] memory _diplomas = new Diploma[](balanceOf(_school));
		uint256 _diplomaCount = 0;
		for (uint256 i = 0; i < _nextTokenId; i++) {
			if (diplomas[i].school == _school) {
				_diplomas[_diplomaCount] = diplomas[i];
				_diplomaCount++;
			}
		}
		return _diplomas;
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal override {
		require(false, "Can't transfer this token ownership");
	}
	
}