import 'package:book_data/sql_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMEDIA',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'SIMEDIA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController jenisController = TextEditingController();
  TextEditingController penulisController = TextEditingController();
  TextEditingController penerbitController = TextEditingController();
  TextEditingController redaksiController = TextEditingController();

  @override
  void initState() {
    refreshCatatan();
    super.initState();
  }

  //ambil data dari database
  List<Map<String, dynamic>> catatan = [];
  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(catatan);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(catatan[index]['judul']),
            subtitle: Text(catatan[index]['penulis']),
            trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => modalForm(catatan[index]['id']),
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () => deleteCatatan(catatan[index]['id']),
                        icon: const Icon(Icons.delete)),
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //fungsi tambah
  Future<void> addCatatan() async {
    await SQLHelper.addCatatan(
        judulController.text,
        jenisController.text,
        penulisController.text,
        penerbitController.text,
        redaksiController.text);
    refreshCatatan();
  }

  //fungsi update
  Future<void> updateCatatan(int id) async {
    await SQLHelper.updateCatatan(
        id,
        judulController.text,
        jenisController.text,
        penulisController.text,
        penerbitController.text,
        redaksiController.text);
    refreshCatatan();
  }

  //fungsi delete
  void deleteCatatan(int id) async {
    await SQLHelper.deleteCatatan(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil hapus data')));
    refreshCatatan();
  }

  //form add
  void modalForm(int id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((element) => element['id'] == id);
      judulController.text = dataCatatan['judul'];
      jenisController.text = dataCatatan['jenis'];
      penulisController.text = dataCatatan['penulis'];
      penerbitController.text = dataCatatan['penerbit'];
      redaksiController.text = dataCatatan['redaksi'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(hintText: 'Judul Buku'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: jenisController,
                      decoration: const InputDecoration(hintText: 'Jenis'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: penulisController,
                      decoration: const InputDecoration(hintText: 'Penulis'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: penerbitController,
                      decoration: const InputDecoration(hintText: 'Penerbit'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: redaksiController,
                      decoration: const InputDecoration(hintText: 'Redaksi'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await addCatatan();
                          } else {
                            await updateCatatan(id);
                          }
                          judulController.text = '';
                          jenisController.text = '';
                          penulisController.text = '';
                          penerbitController.text = '';
                          redaksiController.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(id == null ? 'add' : 'update'))
                  ],
                ),
              ),
            ));
  }
}
