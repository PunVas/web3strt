// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/EvntTktng.sol";

contract EvntTktngTest {
    EvntTktng et;
    uint256 prc = 1000000000000000;

    function beforeEach() public {
        et = new EvntTktng(prc);
    }

    function testOrg() public {
        Assert.equal(et.org(), address(this), "Org should be this contract");
    }

    function testPrc() public {
        Assert.equal(et.tktPrc(), prc, "Prc should be 0.001 ETH");
    }

    function testCrtTkt() public {
        uint256 id = et.crtTkt("QR");
        string memory qr = et.getQR(id);
        Assert.equal(qr, "QR", "QR should match");
    }

    function testBuyTkt() public payable {
        uint256 id = et.crtTkt("QR");
        et.buyTkt{value: prc}(id);
        bool b = et.isBght(id);
        Assert.equal(b, true, "Should be bought");
    }

    function testVldtTkt() public payable {
        uint256 id = et.crtTkt("QR");
        et.buyTkt{value: prc}(id);
        et.vldtTkt(id);
        bool u = et.isUsd(id);
        Assert.equal(u, true, "Should be used");
    }

    function testInvldVldt() public payable {
        try et.vldtTkt(10) {
            Assert.ok(false, 'Should fail');
        } catch Error(string memory r) {
            Assert.equal(r, 'Invalid ticket ID', 'Wrong reason');
        } catch (bytes memory) {
            Assert.ok(false, 'Unexpected fail');
        }
    }

    function testGetQR() public {
        uint256 id = et.crtTkt("QR");
        string memory qr = et.getQR(id);
        Assert.equal(qr, "QR", "QR should match");
    }
}
