### Build LevelDB for iOS
```
git checkout ios
make clean
make library
make clean
make IOS=1 library
make clean
make IOS=2 library
make lipo
```
