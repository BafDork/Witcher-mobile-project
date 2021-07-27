import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TxtFile {

    static Future<String> get _localPath async {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
    }

    static Future<File> localFile(fileName) async {
        final path = await _localPath;
        return File('$path/$fileName');
    }

    static Future<void> writeToFile(String fileName, String content) async {
        final file = await localFile(fileName);
        file.writeAsString(content);
    }

    static Future<String> readFile(String fileName) async {
        try {
            final file = await localFile(fileName);
            String content = await file.readAsString();
            return content;
        }
        catch (er) {
            print(er.message);
        }
        return null;
    }
}

/*
void writeTxt(String text) async {
    int text = await readCounter();
    WidgetsFlutterBinding.ensureInitialized();
    writeTxt('adf');
}
 */

//'assets/data/test.txt' path to assets