import 'package:flutter/material.dart';
import 'constants.dart';
import 'inference.dart';
import 'painter.dart';

class mainScreen extends StatefulWidget{
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen>{
  AppBrain inferencia = AppBrain();
  List<Offset> points = List();
  var numero;
  var porce;

  @override
  void initState(){
    super.initState();
    inferencia.loadModel();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Numbers"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 80.0,),
              Container(
                decoration: new BoxDecoration(
                  border: new Border.all(
                    width: 3.0,
                    color: Colors.blue,
                  ),
                ),
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject();
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanStart: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject();
                          points.add(
                              renderBox.globalToLocal(details.globalPosition));
                        });
                      },
                      onPanEnd: (details) async {
                        points.add(null);
                        List predictions = await inferencia.processCanvasPoints(
                            points);
                        numero=("${predictions[0]["label"]}").toString();
                        porce=("${predictions[0]["confidence"]}").toString();
                        setState(() {});
                      },
                      child: ClipRect(
                        child: CustomPaint(
                          size: Size(kCanvasSize, kCanvasSize),
                          painter: Painter(
                            offsetPoints: points,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              numero==null ? Text(""):Text(numero),
              porce==null ? Text(""):Text(porce),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    child: Text("Delete"),
                    color: Colors.blueGrey,
                    onPressed: () {
                      points.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}