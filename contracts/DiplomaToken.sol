// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DiplomaToken is ERC721 {
    uint256 private _nextTokenId;

    constructor() ERC721("DiplomaToken", "DTK") {}

    struct Diploma {
        string name;
        address school;
        address student;
        string diplomaHash;
        uint256 date;
    }

    mapping(address => string) public schoolNames;
    address[] public schools;
    Diploma[] public diplomas;
    event DiplomaMinted(
        // ✅
        uint256 tokenId,
        string name,
        address school,
        address student,
        string diplomaHash,
        uint256 date
    );
    event SchoolCreated(string name, address school); // ✅

    function createSchool(string memory _name) public {
        // ✅
        schools.push(msg.sender);
        schoolNames[msg.sender] = _name;
        emit SchoolCreated(_name, msg.sender);
    }

    function getSchoolName(
        // ✅
        address schoolAddress
    ) public view returns (string memory) {
        return schoolNames[schoolAddress];
    }

    modifier onlySchool() {
        // ✅
        bool isSchool = false;
        for (uint256 i = 0; i < schools.length; i++) {
            if (schools[i] == msg.sender) {
                isSchool = true;
                break;
            }
        }
        require(isSchool, "Only school can call this function");
        _;
    }

    function createDiploma(
        // ✅
        string memory _name,
        address _student,
        string memory _hash
    ) public onlySchool {
        _safeMint(_student, _nextTokenId);
        _nextTokenId++;
        diplomas.push(
            Diploma({
                name: _name,
                school: msg.sender,
                student: _student,
                diplomaHash: _hash,
                date: block.timestamp
            })
        );
        emit DiplomaMinted(
            _nextTokenId,
            _name,
            msg.sender,
            _student,
            _hash,
            block.timestamp
        );
    }

    function getDiplomasByStudent(
        address _student
    ) public view returns (Diploma[] memory) {
        // ✅
        uint256 count = 0;
        for (uint256 i = 0; i < diplomas.length; i++) {
            if (diplomas[i].student == _student) {
                count++;
            }
        }
        Diploma[] memory myDiplomas = new Diploma[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < diplomas.length; i++) {
            if (diplomas[i].student == _student) {
                myDiplomas[j] = diplomas[i];
                j++;
            }
        }
        return myDiplomas;
    }

    function getSchools() public view returns (address[] memory) {
        // ✅
        return schools;
    }

    function getDiplomasBySchool(
        address _school
    ) public view returns (Diploma[] memory) {
        // ✅
        uint256 count = 0;
        for (uint256 i = 0; i < diplomas.length; i++) {
            if (diplomas[i].school == _school) {
                count++;
            }
        }
        Diploma[] memory myDiplomas = new Diploma[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < diplomas.length; i++) {
            if (diplomas[i].school == _school) {
                myDiplomas[j] = diplomas[i];
                j++;
            }
        }
        return myDiplomas;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(false, "Can't transfer this token's ownership");
        super._transfer(from, to, tokenId);
    }
}
