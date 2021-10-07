cd .\lib\data\proto\protobuf
protoc --dart_out=..\gen config.proto
protoc --dart_out=..\gen task.proto
protoc --dart_out=..\gen ble.proto