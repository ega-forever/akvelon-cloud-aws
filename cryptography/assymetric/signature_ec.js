const crypto = require("crypto"),
    eccrypto = require("eccrypto");

const init = async () => {
    const privateKey = eccrypto.generatePrivate();
    const publicKey = eccrypto.getPublic(privateKey);

    const data = "message to sign";
    const dataHash = crypto.createHash("sha256").update(data).digest();

    const signature = await eccrypto.sign(privateKey, dataHash);
    console.log(`signature: ${signature.toString('hex')}`);

    try {
        await eccrypto.verify(publicKey, dataHash, signature);
        console.log(`signature valid`);
    } catch (e) {
        console.log('signature is not valid');
    }
};

module.exports = init();