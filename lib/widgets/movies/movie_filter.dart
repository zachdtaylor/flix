import 'package:flutter/material.dart';

enum MovieFilter {
  MOST_RECENT,
  LIKED,
  DISLIKED
}

class MovieFilterDialog extends StatefulWidget{
  MovieFilterDialog({Key key, this.value = MovieFilter.MOST_RECENT}) : super(key: key);
  final MovieFilter value;

  static Future<MovieFilter> createDialog(BuildContext context, {MovieFilter currentValue}) async {
    return showDialog<MovieFilter>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MovieFilterDialog(value: currentValue);
      }
    );
  }

  static query(value) {
    if (value != null) {
      if (value == MovieFilter.LIKED) {
        print('liked');
        return 'graphql/users/queries/user_details_filter_liked.gql';
      } else if (value == MovieFilter.DISLIKED) {
        print('disliked');
        return 'graphql/users/queries/user_details_filter_disliked.gql';
      }
    }
    return 'graphql/movies/queries/paginated_movies.gql';
  }

  static movieKey(value) {
    if (value != null) {
      if (value == MovieFilter.LIKED) {
        return 'likedMovies';
      } else if (value == MovieFilter.DISLIKED) {
        return 'dislikedMovies';
      }
    }
    return 'movies';
  }

  @override
  _MovieFilterDialogState createState() => _MovieFilterDialogState();
}

class _MovieFilterDialogState extends State<MovieFilterDialog>{
  MovieFilter _radioValue;

  @override
  initState() {
    super.initState();
    _radioValue = widget.value;
  }

  Widget _optionRow({String text, MovieFilter value}) {
    return Row(
      children: <Widget>[
        Radio<MovieFilter>(
          value: value,
          groupValue: _radioValue,
          onChanged: (newValue) => _handleChange(newValue),
        ),
        GestureDetector(
          onTap: () => _handleChange(value),
          child: Text(
            text,
            style: new TextStyle(fontSize: 16.0),
          )
        ),
      ]
    );
  }

  _handleChange(MovieFilter value){
    setState((){
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text('Filter by...'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            _optionRow(text: 'Most Recently Rated', value: MovieFilter.MOST_RECENT),
            _optionRow(text: 'Liked', value: MovieFilter.LIKED),
            _optionRow(text: 'Disliked', value: MovieFilter.DISLIKED),
          ]
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Save', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop(_radioValue);
          },
        ),
      ],
    );
  }
}
