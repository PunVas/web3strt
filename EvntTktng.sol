// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EvntTktng {
    address public org;
    uint256 public tktPrc;
    mapping(uint256 => Tkt) private tkts;
    uint256 private tktCnt;

    event TktIssd(uint256 tktId);
    event TktBght(uint256 tktId, address indexed byr);
    event TktVldtd(uint256 tktId);

    struct Tkt {
        bool bght;
        bool usd;
        string qr;
    }

    constructor(uint256 _tktPrc) {
        org = msg.sender;
        tktPrc = _tktPrc;
    }

    modifier onlyOrg() {
        require(msg.sender == org, "Only the organizer can perform this action");
        _;
    }

    modifier tktEx(uint256 tktId) {
        require(tktId > 0 && tktId <= tktCnt, "Invalid ticket ID");
        _;
    }

    function crtTkt(string calldata _qr) public onlyOrg returns (uint256) {
        tktCnt++;
        tkts[tktCnt] = Tkt({
            bght: false,
            usd: false,
            qr: _qr
        });
        emit TktIssd(tktCnt);
        return tktCnt;
    }

    function buyTkt(uint256 tktId) public payable tktEx(tktId) {
        require(msg.value == tktPrc, "Wrong ticket price");
        require(!isBght(tktId), "Already purchased");

        tkts[tktId].bght = true;
        emit TktBght(tktId, msg.sender);
    }

    function vldtTkt(uint256 tktId) public onlyOrg tktEx(tktId) {
        require(!isUsd(tktId), "Ticket has already been used");

        tkts[tktId].usd = true;
        emit TktVldtd(tktId);
    }

    function getQR(uint256 tktId) public view tktEx(tktId) returns (string memory) {
        return tkts[tktId].qr;
    }

    function isBght(uint256 tktId) public view tktEx(tktId) returns (bool) {
        return tkts[tktId].bght;
    }

    function isUsd(uint256 tktId) public view tktEx(tktId) returns (bool) {
        return tkts[tktId].usd;
    }
}
