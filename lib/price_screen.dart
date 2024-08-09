import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String price = '?';
  Map<String, String> priceMap = {};

  CupertinoPicker iOSPicker() {
    List<Text> iOSLst = [];
    for (String currency in currenciesList) {
      iOSLst.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: iOSLst,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> androidLst = [];
    for (String currency in currenciesList) {
      androidLst.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: androidLst,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            getData();
          },
        );
      },
    );
  }

  List<Card> getCardData() {
    List<Card> cardList = [];
    for (int i = 0; i < cryptoList.length; i++) {
      cardList.add(
        Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 ${cryptoList[i]} = ${priceMap.length > 0 ? priceMap[cryptoList[i]] : price} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 15.0),
        ),
      );
    }
    return cardList;
  }

  void getData() async {
    try {
      Map<String, double> data =
          await CoinData(currency: selectedCurrency).getCoinData();
      setState(() {
        for (var crypto in data.entries)
          priceMap[crypto.key] = crypto.value.toStringAsFixed(0);
      });
    } catch (e) {
      print('Exception!!!');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCardData(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
