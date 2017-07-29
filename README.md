# batch-cryptor

This bash program is used to batch encrypt and deploy file structures recursivley into monitored folders (Google Drive, OneDrive, etc).

## Examples

#### To Encrypt:
```bash
./batch-cryptor.sh -s /home/user/media1/Local-Vault/ -t /home/user/Drive/Vault/
```

#### To Decrypt:
```bash
./batch-cryptor.sh -t /home/user/media1/Local-Vault/ -s /home/user/Drive/Vault/ -d
```

*Note the placement of the -t and -s argument flags.*

 
![alt text](http://cf.chucklesnetwork.com/items/7/5/6/5/2/original/yo-dawg-i-heard-you-like-encryption-so-i-encrypted-your-encrypti.jpg "Bye Felica")
