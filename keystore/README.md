# Innerverse Android Keystore

## Generating the Keystore

Run this command to generate the release keystore:

```bash
keytool -genkey -v \
  -keystore innerverse.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias innerverse \
  -storepass innerverse2024 \
  -keypass innerverse2024 \
  -dname "CN=Innerverse, OU=Development, O=Innerverse, L=Earth, ST=Mind, C=UN"
```

## Credentials (for private repos only!)

- **Store Password:** innerverse2024
- **Key Alias:** innerverse
- **Key Password:** innerverse2024

## Important Notes

1. Keep this keystore safe - losing it means you can't update your app on Play Store
2. These credentials are only safe because this repo is private
3. For production apps, use GitHub Secrets instead
