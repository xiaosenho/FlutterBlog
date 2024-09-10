import 'package:flutter/material.dart';
import 'package:flutter2/pages/articlesListView.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin{
  //使用 AutomaticKeepAliveClientMixin 保持页面状态
  @override
  bool get wantKeepAlive => true;
  String url='/article/latestArticles';
  String _keyword = '';
  String _selectedSortingOption = '按时间排序';
  String _selectedCategory = '所有';
  
  @override
  void initState() {
    super.initState();
  }


  //回调函数，供搜索提交调用
  void changeKeyword(String keyword){
    setState(() {
      _keyword=keyword;
      url='/article/searchArticles?keyword=$_keyword&order=$_selectedSortingOption&category=$_selectedCategory';
    });
  }
  void changeCategory(String category){
    setState(() {
      _selectedCategory=category;
      url='/article/searchArticles?keyword=$_keyword&order=$_selectedSortingOption&category=$_selectedCategory';
    });
  }
  void changeSortingOption(String option){
    setState(() {
      _selectedSortingOption=option;
      url='/article/searchArticles?keyword=$_keyword&order=$_selectedSortingOption&category=$_selectedCategory';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(callback: changeKeyword,),
      body: NestedScrollView(//使用NestedScrollView嵌套滚动组件来包装ListView，保证子组件的滑动监听器生效
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: CategorySearch(changeCategory: changeCategory,changeSorting: changeSortingOption,),
            ),
          ];
        },
        body: ArticleListView(key: UniqueKey(), pageSize: 10, isStaticPage: false, url: url),
      ),
    );
  }
}

class SearchBar extends StatefulWidget implements PreferredSizeWidget  {
  @override
  _SearchBarState createState() => _SearchBarState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  // 接收回调函数
  final Function callback;

  SearchBar({Key? key, required this.callback}) : super(key: key);
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AppBar(
        backgroundColor: themeData.colorScheme.surface.withOpacity(0),//不透明度设置为0
        titleTextStyle: themeData.textTheme.headlineLarge,
        title: _isSearching ? _buildSearchField(themeData) : const Text('文章检索'),
        actions: _buildActions(),
      );
  }

  Widget _buildSearchField(ThemeData themeData) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: '搜索…',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xFF0D253C)),
      ),
      style: themeData.textTheme.headlineMedium,
      onSubmitted: (query) {
        widget.callback(query);
        // 搜索完成后，关闭搜索模式
        setState(() {
          _isSearching = false;
        });
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              setState(() {
                _isSearching = false;
              });
            } else {
              _searchController.clear();
            }
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }
}

class CategorySearch extends StatefulWidget {
  const CategorySearch({Key? key, required this.changeCategory, required this.changeSorting}) : super(key: key);
  final Function changeCategory;
  final Function changeSorting;
  @override
  State<CategorySearch> createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  String _selectedSortingOption = '按时间排序';
  String _selectedCategory = '所有';

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(height: 16),
        Row(
          children: <Widget>[
            Text('排序方式:',
            style: themeData.textTheme.displayMedium,
            ),
            OptionButton(
                      text: '按时间排序',
                      isSelected: _selectedSortingOption == '按时间排序',
                      onPressed: () {
                        widget.changeSorting('按时间排序');
                        setState(() {
                          _selectedSortingOption = '按时间排序';
                        });
                      },
                    ),
            OptionButton(
                      text: '按热度排序',
                      isSelected: _selectedSortingOption == '按热度排序',
                      onPressed: () {
                        widget.changeSorting('按热度排序');
                        setState(() {
                          _selectedSortingOption = '按热度排序';
                        });
                      },
                    ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: <Widget>[
            Text('类别:',
            style: themeData.textTheme.displayMedium,),
            Expanded(
              child:SingleChildScrollView(
                scrollDirection: Axis.horizontal, 
                child:Row(
                  children: <Widget>[
                    OptionButton(
                      text: '所有',
                      isSelected: _selectedCategory == '所有',
                      onPressed: () {
                        widget.changeCategory('所有');
                        setState(() {
                          _selectedCategory = '所有';
                        });
                      },
                    ),
                    OptionButton(
                      text: '科技',
                      isSelected: _selectedCategory == '科技',
                      onPressed: () {
                        widget.changeCategory('科技');
                        setState(() {
                          _selectedCategory = '科技';
                        });
                      },
                    ),
                    OptionButton(
                      text: '娱乐',
                      isSelected: _selectedCategory == '娱乐',
                      onPressed: () {
                        widget.changeCategory('娱乐');
                        setState(() {
                          _selectedCategory = '娱乐';
                        });
                      },
                    ),
                    OptionButton(
                      text: '生活',
                      isSelected: _selectedCategory == '生活',
                      onPressed: () {
                        widget.changeCategory('生活');
                        setState(() {
                          _selectedCategory = '生活';
                        });
                      },
                    ),
                    OptionButton(
                      text: '旅行',
                      isSelected: _selectedCategory == '旅行',
                      onPressed: () {
                        widget.changeCategory('旅行');
                        setState(() {
                          _selectedCategory = '旅行';
                        });
                      },
                    ),
                    OptionButton(
                      text: '互联网',
                      isSelected: _selectedCategory == '互联网',
                      onPressed: () {
                        widget.changeCategory('互联网');
                        setState(() {
                          _selectedCategory = '互联网';
                        });
                      },
                    ),
                    OptionButton(
                      text: '经济',
                      isSelected: _selectedCategory == '经济',
                      onPressed: () {
                        widget.changeCategory('经济');
                        setState(() {
                          _selectedCategory = '经济';
                        });
                      },
                    ),
                  ],
                ),
              )
            )
          ]
        ),
        SizedBox(height: 16), 
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  OptionButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeData= Theme.of(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? themeData.colorScheme.secondaryContainer : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}