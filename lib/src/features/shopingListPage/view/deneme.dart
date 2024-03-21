import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfDemo(),
    );
  }
}

class PdfDemo extends StatelessWidget {
  final pdf = pw.Document();
  final List<String> imageUrls = [
    // Firebase Storage'dan alınan resim URL'lerini buraya ekleyin
    'url_1',
    'url_2',
    // Diğer resim URL'leri...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase\'den Resimleri Tek Sayfaya Ekleme'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            addImagesToPdf();
          },
          child: Text('Resimleri PDF\'e Ekle'),
        ),
      ),
    );
  }

  // Firebase'den alınan resimleri tek sayfaya PDF'e ekleyen fonksiyon
  Future<void> addImagesToPdf() async {
    final appDir = await getApplicationDocumentsDirectory();

    final List<pw.Widget> imageWidgets = [];

    for (int i = 0; i < imageUrls.length; i++) {
      final response = await http.get(Uri.parse(imageUrls[i]));
      final bytes = response.bodyBytes;
      final imageFile = File('${appDir.path}/image_$i.jpg');
      await imageFile.writeAsBytes(bytes);

      final imageProvider = pw.MemoryImage(
        imageFile.readAsBytesSync(),
      );

      // Her resmi tek bir satıra ekleyin
      imageWidgets.add(
        pw.Container(
          margin: pw.EdgeInsets.only(bottom: 10),
          child: pw.Image(imageProvider),
        ),
      );
    }

    // Tüm resimleri bir dizi içinde tek bir sayfaya ekleyin
    final pdfPage = pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: imageWidgets,
          ),
        );
      },
    );

    pdf.addPage(pdfPage);

    final pdfFile = File('${appDir.path}/example.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // PDF dosyası oluşturulduğunda kullanıcıya mesaj göstermek için bir dialog açabilirsiniz.
    
  }
}
