// e1547: A mobile app for browsing e926.net and friends.
// Copyright (C) 2017 perlatus <perlatus@e1547.email.vczf.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:logging/logging.dart' show Logger;

class RangeDialog extends StatefulWidget {
  RangeDialog({this.title, this.value, this.max});

  final String title;
  final int value;
  final int max;

  @override
  RangeDialogState createState() => new RangeDialogState();
}

class RangeDialogState extends State<RangeDialog> {
  final Logger _log = new Logger('RangeDialog');

  TextEditingController _controller = new TextEditingController();
  int _value;

  void _setValue(String v) {
    setState(() {
      _value = int.parse(v);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    _value = _value ?? widget.value;
    return new SimpleDialog(
        title: new Text('Posts with ${widget.title} at least'),
        children: <Widget>[
          _buildNumber(ctx),
          _buildSlider(ctx),
          _buildButtons(ctx),
        ]);
  }

  Widget _buildNumber(BuildContext ctx) {
    _controller.text = _value.toString();

    Widget number = new TextField(
      keyboardType: TextInputType.number,
      style: new TextStyle(fontSize: 48.0),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(hideDivider: true),
      controller: _controller,
      onChanged: _setValue,
      onSubmitted: (v) => Navigator.of(ctx).pop(int.parse(v)),
    );

    return new Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: number,
    );
  }

  Widget _buildSlider(BuildContext ctx) {
    return new Slider(
        min: 0.0,
        max: widget.max.toDouble(),
        divisions: 50,
        value: _value.toDouble(),
        onChanged: (v) {
          _log.info('${widget.title} filter value: $v');
          setState(() => _value = v.toInt());
        });
  }

  Widget _buildButtons(BuildContext ctx) {
    List<Widget> buttons = [
      new FlatButton(
        child: new Text('cancel'),
        onPressed: () => Navigator.of(ctx).pop(),
      ),
      new RaisedButton(
        child: new Text('save'),
        onPressed: () => Navigator.of(ctx).pop(_value),
      ),
    ];

    return new Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: buttons,
      ),
    );
  }
}
