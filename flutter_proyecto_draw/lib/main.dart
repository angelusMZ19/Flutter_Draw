import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Flutter',
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Stroke {
  final Path path;
  final Color color;

  Stroke(this.path, this.color);
}

class _MyHomePageState extends State<MyHomePage> {
  final _strokes = <Stroke>[];
  Color currentColor = Color.fromARGB(255, 0, 0, 0);
  Color bgColor = Color.fromARGB(255, 32, 188, 170); // Color del trazo borrador

  void _startStroke(double x, double y) {
    _strokes.add(Stroke(Path()..moveTo(x, y), currentColor));
  }

  void _moveStroke(double x, double y) {
    setState(() {
      _strokes.last.path.lineTo(x, y);
    });
  }

  void _clearBoard() {
    setState(() {
      _strokes.clear();
    });
  }

  void _toggleEraser() {
    setState(() {
      currentColor = currentColor == bgColor
          ? const Color.fromARGB(255, 6, 41, 37)
          : bgColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Flutter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearBoard,
          ),
          IconButton(
            icon: Icon(MdiIcons.eraser),
            onPressed: _toggleEraser,
          ),
          // IconButton(
          //   icon: const Icon(Icons.create),
          //   onPressed: () => _moveStroke(x, y),
          // )
        ],
      ),
      body: GestureDetector(
        onPanDown: (details) => _startStroke(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
        onPanUpdate: (details) => _moveStroke(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
        child: Container(
          color: bgColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: DrawingPainter(_strokes),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..strokeWidth = 5
        ..color = stroke.color
        ..style = PaintingStyle.stroke;

      canvas.drawPath(stroke.path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
