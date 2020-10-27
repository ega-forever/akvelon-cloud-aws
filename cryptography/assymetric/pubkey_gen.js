const eccrypto = require("eccrypto"),
    EC = require("elliptic").ec,
    BN = require('BN.js'),
    ec = new EC("secp256k1");

const init = async () => {
    const privateKey = eccrypto.generatePrivate();
    console.log(`private key: ${privateKey.toString('hex')}`);
    const publicKey = eccrypto.getPublic(privateKey);
    console.log(`public key: ${publicKey.toString('hex')}`);

    console.log(`G point: ${ec.g.encode('hex')}`);

    const calculatedPublicKey = ec.g.mul(new BN(privateKey.toString('hex'), 16)).encode('hex', false);
    console.log(`is public key calculated right: ${calculatedPublicKey === publicKey.toString('hex')}`);
};

module.exports = init();