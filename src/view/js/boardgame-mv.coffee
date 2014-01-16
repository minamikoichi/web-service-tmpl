root = exports ? this

makeLocation = ( path ) ->
  location = window.location.protocol + '//' + window.location.host + path

class BoardgameBlogViewModel
  constructor: () ->
    @title = ko.observable '日曜ボードゲーム'
    @article = ko.observableArray []
    @articleType = ko.observable 'blog-item-summary'
    @blogItem = [] # 日付順に並べる
    @nextPollPageNumber = 1
    @ROOTPATH = '/boardgame/'
    @PAGEQUERY    = @ROOTPATH + 'view/page/'
    @IDQUERY      = @ROOTPATH + 'view/id/'    
    @init= (pathname) ->
      vm = @
      if pathname == @ROOTPATH
        @nextPollPageNumber = 1        
        @pullBlogItem()
      else if pathname.match(@PAGEQUERY+"([0-9]+)")
        ret = pathname.match(@PAGEQUERY+"([0-9]+)")
        pageNumber = parseInt ret[1]
        @nextPollPageNumber = pageNumber
        @pullBlogItem()        
      else 
        @transition pathname
    # ページ単位での記事取得
    @pullBlogItem = () ->
      vm = @
      $.ajax '/data/boardgame/view/page/' + @nextPollPageNumber + '/',
        type : 'GET',
        dataType: 'json',
        success: (data, textStatus, jqXHR) ->
          unless vm.articleType() == 'blog-item-summary'
            return
          vm.nextPollPageNumber++
          vm.articleType(data.type)
          # vm.article.removeAll()  removeしない
          unless (_.find vm.article , (i) -> i.id == data.data.id)
            vm.article.push item for item in data.data
            vm.blogItem.push item for item in data.data          
          _.sortBy vm.blogItem , (d) -> return d.date
    # 記事取得
    @itemLinkClick = (dstId,data,event) ->
      vm = @
      path = '/boardgame/view/id/' + dstId + '/'
      # 既に取得している場合はそれを表示する
      item = _.find @blogItem , (i) -> i.id == dstId      
      if item
        vm.articleType('blog-item')
        vm.article.removeAll()
        $('html,body').scrollTop 0         
        vm.article.push item
        root.appRouter.navigate path
      else
        @transition path
    # ページの取得
    @transition = (path,callback) ->
      vm = @
      root.appRouter.navigate path      
      $.ajax '/data' + path,
        type : 'GET',
        cache: true,
        dataType: 'json',
        success: (data, textStatus, jqXHR) ->
          vm.articleType(data.type)
          vm.article.removeAll()
          $('html,body').scrollTop 0
          vm.article.push item for item in data.data
          vm.blogItem.push item for item in data.data
          _.sortBy vm.blogItem , (d) -> return d.date
    # ページ末尾到達時の処理
    @endPageAction = () ->
      if @articleType() == 'blog-item-summary'
        @pullBlogItem()
