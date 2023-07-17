using Azure.Identity;
using Azure.Security.KeyVault.Keys;
using Azure.Security.KeyVault.Keys.Cryptography;
using System.Text;

string tenantId = "70c0f6d9-7f3b-4425-a6b6-09b47643ec58";
string clientId = "b4d0b1b0-21f6-4b57-a6cc-ca982114e340";
string clientSecret = "1ym8Q~uaRr2d5LtGSB9K36JxhJzN-MB2iMxirbyr";

string keyvaultUrl = "https://appvault600909.vault.azure.net/";
string keyName = "appkey";
string textToEncrypt = "This a secret text";

ClientSecretCredential clientSecretCredential = new ClientSecretCredential(tenantId, clientId, clientSecret);

KeyClient keyClient = new KeyClient(new Uri(keyvaultUrl), clientSecretCredential);

var key = keyClient.GetKey(keyName);

// The CryptographyClient class is part of the Azure Key vault package
// This is used to perform cryptographic operations with Azure Key Vault keys
var cryptoClient = new CryptographyClient(key.Value.Id, clientSecretCredential);

// We first need to take the bytes of the string that needs to be converted

byte[] textToBytes = Encoding.UTF8.GetBytes(textToEncrypt);

EncryptResult result = cryptoClient.Encrypt(EncryptionAlgorithm.RsaOaep, textToBytes);

Console.WriteLine("The encrypted text");
Console.WriteLine(Convert.ToBase64String(result.Ciphertext));

// Now lets decrypt the text
// We first need to convert our Base 64 string of the Cipertext to bytes

byte[] ciperToBytes = result.Ciphertext;

DecryptResult textDecrypted = cryptoClient.Decrypt(EncryptionAlgorithm.RsaOaep, ciperToBytes);

Console.WriteLine(Encoding.UTF8.GetString(textDecrypted.Plaintext));

Console.ReadKey();






